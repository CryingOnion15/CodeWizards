class_name CodeEntryPanel extends CodePanel

var parameter_pin = preload("res://Scenes/Pins/ParameterPin.tscn");
var start_pin: Pin = null;

@export var parameter_container: Node = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
	start_pin = available_pins[0];
	#TODO add support for parameters in the Entry Panel.
	# Idea is that all of the parameters passed to this wand,
	# are added as pins to drag out to.
	
func Execute():
	pass
	# TODO Set starting pin values.
	
func get_next_control() -> CodePanel:
	if(start_pin.connectedTo):
		return start_pin.connectedTo.get_value();
	return null;
	
func set_parameters(params: Dictionary):
	for param in params.keys():
		var name = param;
		var value = params[param];
		
		var param_pin = parameter_pin.instantiate();
		parameter_container.add_child(param_pin);
		
		var label = param_pin.get_node("ParamName") as Label;
		var pin = param_pin.get_node("Pin") as Pin;
		label.text = name;
		
		if value is String:
			pin.data_type = Pin.DATA_TYPE.STRING;
		if value is float:
			pin.data_type = Pin.DATA_TYPE.NUMBER;
		
		pin.pin_type = Pin.PIN_TYPE.CONNECTOR;
		pin.set_value(value);
		
		
