class_name PinConnectionUtility extends RefCounted

static var pins: Dictionary[String, Pin] = {};
static var connections: Dictionary[String, String] = {};

static func add_pin(id: String, pin: Pin):
	pins.set(id, pin);
	
static func remove_pin(id: String):
	#TODO remove connections.
	
	pins.erase(id);
	
static func get_pin_from_id(id: String):
	return pins.get(id);
	
static func add_connection(from: String, to: String):
	if from == "":  
		push_error("From ID is empty.");
	elif to == "":
		push_error("To ID ids is empty.");
	else:
		connections.set(from, to);
	
static func remove_connection(from: String, to: String):
	pass;
	
static func verify_connections():
	for connection in connections.keys():
		var test = connections[connection];
		var test2 = connection;
		
		var keys = pins.keys();
		var values = pins.values();
		
		var from: Pin = pins.get(connection);
		var to: Pin = pins.get(connections[connection]);
		
		if to && from:
			from.connect_to_id(to.id);
			to.connect_to_id(from.id);
		else:
			push_error("Connection could not be verified. FROM: %s | TO: %s", [from,to]);
