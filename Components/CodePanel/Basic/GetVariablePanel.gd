class_name GetVariablePanel extends CodePanel

@export var var_name_label: RichTextLabel = null;
@export var value_pin: Pin = null;

var reference_pin: Pin = null;
var parent_wand: String = "";
var variable_name: String = "";

func  _ready():
	super._ready();
	
	for pin in available_pins:
		if pin.pin_type == pin.PIN_TYPE.CONNECTOR && pin.data_type == pin.DATA_TYPE.REFERENCE:
			reference_pin = pin;
			
func get_save_data():
	var save_data = super.get_save_data();
	
	var new = {
		"parentID": parent_wand,
		"varName": variable_name,
	}
	
	save_data.merge(new);
	return save_data;
	
func init_panel():
	super.init_panel();
	
	if not meta_data.is_empty():
		parent_wand = meta_data.get("parentID", "");
		variable_name = meta_data.get("varName", "");

func set_wand_variable(wand: Wand, var_name: String):
	parent_wand = wand.id;
	variable_name = var_name;
	
	if reference_pin:
		reference_pin.set_value("%s:%s" % [id, "get_reference_value"] );
		var_name_label.text = variable_name;
		
		value_pin.pin_type = Pin.PIN_TYPE.CONNECTOR;
		
		var current_var_value = wand.get_variable_value(variable_name);
		
		if current_var_value is String:
			value_pin.data_type = Pin.DATA_TYPE.STRING;
		if current_var_value is float:
			value_pin.data_type = Pin.DATA_TYPE.NUMBER;
		
		value_pin.set_value("%s:%s" % [id, "get_value"]);
	else:
		push_error("Reference Pin not set.");

func get_reference_value():
	return [parent_wand, variable_name];
	
func get_value():
	var wand = WandDataUtility.get_wand(parent_wand);
	return wand.get_variable_value(variable_name);

func success(drop_type: DropData.DropType):
	#super.success(drop_type);
	
	match drop_type:
		DropData.DropType.CARD:
			#Delete this panel.
			disconnect_all_pins();
			queue_free();
		DropData.DropType.RAM:
			pass;
