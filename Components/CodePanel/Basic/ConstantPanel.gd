class_name ConstantPanel extends CodePanel

@export var value_label: RichTextLabel;

var output_pin: Pin = null;
var variable_number_value: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	if(output_pin == null && $OutputPin is Pin):
		output_pin = $OutputPin as Pin;
	update_visuals();

func init_drop():
	update_visuals();

func update_visuals():
	output_pin.set_value(variable_number_value);
	value_label.text = "%s" % [variable_number_value];
	
func set_data(data: Dictionary):
	super.set_data(data);
	variable_number_value = save_data["value"];
	
	if(output_pin == null && $OutputPin is Pin):
		output_pin = $OutputPin as Pin;
	
	update_visuals();	
