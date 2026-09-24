class_name GetVariablePanel extends CodePanel

var reference_pin: Pin = null;

func  _ready():
	super._ready();
	
	for pin in available_pins:
		if pin.pin_type == pin.PIN_TYPE.CONNECTOR && pin.data_type == pin.DATA_TYPE.REFERENCE:
			reference_pin = pin;

#TODO change want to Type Wand.
func set_wand_variable(wand: Node, variable_name: String):
	if reference_pin:
		reference_pin.set_value([wand, variable_name]);
	else:
		push_error("Reference Pin not set.");
