class_name PinConnectionManager extends Node

static var pins: Dictionary[String, Pin] = {};
static var connections: Dictionary[String, String] = {};
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
		connections.set(from, to);
	
static func remove_connection(from: String, to: String):
	pass;
	
static func get_connection_value_callback(panelID, functionName, arguments = []):
	var test = panels.get(panelID);
	if test:
		return func(): return panels.get(panelID).callv(functionName, arguments);
	else:
		push_error("Panel ID %s not registered. Method Name: %s" % [panelID, functionName]);
		return func(): return "";
		
static func verify_connections():
	for connection in connections.keys():		
		var keys = pins.keys();
		var values = pins.values();
		
		var from: Pin = pins.get(connection);
		var to: Pin = pins.get(connections[connection]);
		
		if to && from:
			from.connect_to_id(to.id);
			to.connect_to_id(from.id);
		else:
			push_error("Connection could not be verified. FROM: %s | TO: %s" % [from,to]);
			
static func verify_values():
	for pin in pins.values():
		pin.parse_and_set_value();
