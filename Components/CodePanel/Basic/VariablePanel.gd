class_name VariablePanel extends CodePanel

@export var value_label: RichTextLabel;

var outputPin: Pin = null;
var variable_number_value: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	if(outputPin == null && $OutputPin is Pin):
		outputPin = $OutputPin as Pin;
		updateVisuals();

func updateVisuals():
	outputPin.set_value(variable_number_value);
	value_label.text = "%s" % [variable_number_value];
	
func set_data(data: Dictionary):
	super.set_data(data);
	variable_number_value = save_data["value"];
	
	if(outputPin == null && $OutputPin is Pin):
		outputPin = $OutputPin as Pin;
	
	updateVisuals();	
