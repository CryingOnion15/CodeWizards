class_name SetVariablePanel extends FunctionPanel

@export var reference_pin: Pin = null;
@export var value_pin: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();	
	reference_pin.pin_connected.connect(on_reference_connected);
	reference_pin.pin_reset.connect(on_reference_disconnected);
	
func on_reference_connected():
	var wand_tuple = reference_pin.get_value(true);
	var wand: Wand = wand_tuple[0] #as Wand;
	var variable_name: String = wand_tuple[1];
	var var_value = wand.get_variable_value(variable_name);
	
	if var_value is String:
		value_pin.data_type = Pin.DATA_TYPE.STRING;
	if var_value is float:
		value_pin.data_type = Pin.DATA_TYPE.NUMBER;
		
	value_pin.show();

func on_reference_disconnected():
	value_pin.hide();
	minimum_size_changed.emit();
	
func Execute():	
	var wand_tuple = reference_pin.get_value(true);
	
	if wand_tuple:
		var wand: Wand = wand_tuple[0] #as Wand;
		var variable_name: String = wand_tuple[1];
		wand.set_variable_value(variable_name, value_pin.get_value(true));
