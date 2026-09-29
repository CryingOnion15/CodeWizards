class_name GetVariablePanel extends CodePanel

@export var var_name_label: RichTextLabel = null;
@export var value_pin: Pin = null;

var reference_pin: Pin = null;
var parent_wand: Wand = null;

func  _ready():
	super._ready();
	
	for pin in available_pins:
		if pin.pin_type == pin.PIN_TYPE.CONNECTOR && pin.data_type == pin.DATA_TYPE.REFERENCE:
			reference_pin = pin;

#TODO change want to Type Wand.
func set_wand_variable(wand: Wand, variable_name: String):
	parent_wand = wand;
	
	if reference_pin:
		reference_pin.set_value(func(): return [parent_wand, variable_name]);
		var_name_label.text = variable_name;
		
		value_pin.pin_type = Pin.PIN_TYPE.CONNECTOR;
		
		var current_var_value = parent_wand.get_variable_value(variable_name);
		
		if current_var_value is String:
			value_pin.data_type = Pin.DATA_TYPE.STRING;
		if current_var_value is float:
			value_pin.data_type = Pin.DATA_TYPE.NUMBER;
		
		#TODO need to puzzle through how to get the value via a function so variable value can be different during execution.
		value_pin.set_value(func(): return parent_wand.get_variable_value(variable_name));
	else:
		push_error("Reference Pin not set.");
		
func success(drop_type: DropData.DropType):
	#super.success(drop_type);
	
	match drop_type:
		DropData.DropType.CARD:
			#Delete this panel.
			disconnect_all_pins();
			queue_free();
		DropData.DropType.RAM:
			pass;
