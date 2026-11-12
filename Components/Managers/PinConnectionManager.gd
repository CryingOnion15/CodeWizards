class_name PinConnectionManager extends Node

static var pins: Dictionary[String, Pin] = {};
static var connections: Dictionary[String, Array] = {};
static var panels: Dictionary[String, CodePanel] = {};
static var value_callbacks: Dictionary[String, String] = {} #ID of panel and method name.
static var connection_pool: Array[PinConnection] = [];
static var connection_scene = preload("res://Scenes/Pins/PinConnection.tscn");

static var instance;


func _ready():
	PinConnectionManager.instance = self;

static func add_pin(id: String, pin: Pin):
	pins.set(id, pin);
	
static func register_panel(id: String, panel: CodePanel):
	panels.set(id, panel);
	
static func remove_pin(id: String):
	#TODO remove connections.
	
	pins.erase(id);
	
static func get_pin_from_id(id: String):
	return pins.get(id);

static func request_new_connection()-> PinConnection:
	if connection_pool.size() == 0:
		var new_connection = connection_scene.instantiate();
		PinConnectionManager.instance.add_child(new_connection);
		return new_connection;
	else:
		var connection = connection_pool.pop_front();
		connection.show();
		return connection;
		
static func add_connection_to_pool(connection: PinConnection):
	
	if connection.owner_pin && connection.connector_pin:
		remove_connection(connection.owner_pin.id, connection.connector_pin.id);
		
	connection_pool.push_back(connection);
	connection.owner_pin = null;
	connection.connector_pin = null;
	connection.reparent(PinConnectionManager.instance);
	connection.hide();
	
static func add_connection(from: String, to: String):
	if from == "":  
		push_error("From ID is empty.");
	elif to == "":
		push_error("To ID ids is empty.");
	else:
		connections.get_or_add(from, []).push_back(to);
	
static func remove_connection(from: String, to: String):
	var to_array = connections.get_or_add(from, []);
	
	var index = to_array.find_custom(
		func(id): return id == to;
	)
	
	if index != -1:
		to_array.pop_at(index);
	
static func get_connection_value_callback(panelID, functionName, arguments = []):
	var test = panels.get(panelID);
	if test:
		return func(): return panels.get(panelID).callv(functionName, arguments);
	else:
		push_error("Panel ID %s not registered. Method Name: %s" % [panelID, functionName]);
		return func(): return "";
		
static func verify_connections():
	var test = connections;
	for connection in connections.keys():				
		var from: Pin = pins.get(connection);
		var to_array: Array = connections[connection];
		
		for to in to_array:
			var to_pin = pins.get(to)
			
			if from.has_connection(to_pin):
				continue;
				
			if to && from:
				from.connect_to_id(to);
			else:
				push_error("Connection could not be verified. FROM: %s | TO: %s" % [from,to]);
			
static func verify_values():
	for pin in pins.values():
		pin.parse_and_set_value();
