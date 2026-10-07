class_name CodeEntryPanel extends CodePanel

signal execution_started;

var parameter_pin = preload("res://Scenes/Pins/ParameterPin.tscn");
var start_pin: Pin = null;
var parameters: Dictionary = {};

@export var parameter_container: Node = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normal_type = 0;
	nest_type = 0;
	
	super._ready();
	
	start_pin = available_pins[0];
	
func Execute():
	execution_started.emit();
	
func get_next_control() -> CodePanel:
	if(start_pin.connectedTo):
		return start_pin.connectedTo.get_value();
	return null;
	
func setup_pins():
	super.setup_pins();
	
	if not parameters.is_empty():
		for param in parameters.keys():
			var name = param;
			var value = parameters[param];
			
			var param_pin = parameter_pin.instantiate();
			parameter_container.add_child(param_pin);
			
			var label = param_pin.get_node("ParamName") as Label;
			var pin = param_pin.get_node("Pin") as Pin;
			available_pins.push_back(pin);
			label.text = name;
			
			#TODO this should be evaluate differently because the type is predetermined.
			if value is String:
				pin.data_type = Pin.DATA_TYPE.STRING;
			if value is float:
				pin.data_type = Pin.DATA_TYPE.NUMBER;
				
			if not pin.isConnected:
				pin.reset();
			else:
				pin.emit_connected();
			
			pin.pin_type = Pin.PIN_TYPE.CONNECTOR;
			pin.set_value("%s:%s:%s" % [id, "get_panel_value", name]);
	
func set_parameters(params: Dictionary):
	parameters = params;

func get_panel_value(name):
	return parameters[name]
