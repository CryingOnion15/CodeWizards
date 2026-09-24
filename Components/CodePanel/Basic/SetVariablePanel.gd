class_name SetVariablePanel extends FunctionPanel

var reference_pin: Pin = null;
var value_pin: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	#Node sure if this is guarenteed or not.
	reference_pin = input_pins[0];
	value_pin = input_pins[1];
	
	reference_pin.pin_connected.connect(on_reference_connected);
	reference_pin.pin_reset.connect(on_reference_disconnected);
	
func on_reference_connected():
	#TODO make value pin visible and set type.
	pass;

func on_reference_disconnected():
	#TODO make value pin invisible.
	pass;
	
func Execute():
	var wand_tuple = reference_pin.get_value(true);
	var wand = wand_tuple[0] #as Wand;
	var variable_name = wand_tuple[1];
	
	#wand.set_variable(variable_name, value_pin.get_value(true);
