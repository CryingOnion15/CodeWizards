class_name ConstantPanel extends CodePanel

@export var value_label: RichTextLabel;
@export var output_pin: Pin = null;
var number_value: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	if(output_pin == null && $OutputPin is Pin):
		output_pin = $OutputPin as Pin;
	update_visuals();
	
func get_save_data():
	var save_data = super.get_save_data();
	
	var new = {
		"numberValue": number_value
	}
	
	save_data.merge(new);
	return save_data;

func init_panel():
	super.init_panel();
	
	if not meta_data.is_empty():
		number_value = meta_data.get("numberValue", 0);

func init_drop():
	update_visuals();

func update_visuals():
	if output_pin: 
		output_pin.set_value("%s:%s" % [id,"get_panel_value"]);
		value_label.text = "%s" % [number_value];

func get_panel_value():
	return number_value
	
func set_data(data: Dictionary):
	super.set_data(data);
	number_value = data["value"];	
	update_visuals();	
