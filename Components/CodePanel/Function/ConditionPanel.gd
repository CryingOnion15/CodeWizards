class_name ConditionPanel extends NestedPanel

enum COND_TYPE {
	LESS,
	LESSEQ,
	EQ,
	GREATEREQ,
	GREATER,
	NOTEQ
}

@export var cond_type: COND_TYPE = COND_TYPE.LESS;
#TODO need to implement the text for this. Probably some color for good ux.
@export var condition_description_label: RichTextLabel;
@export var cond_label: RichTextLabel;

@export var nested_true_inflow_pin: Pin = null;
@export var nested_true_outflow_pin: Pin = null;
@export var nested_false_inflow_pin: Pin = null;
@export var nested_false_outflow_pin: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
	match cond_type:
		COND_TYPE.LESS:
			cond_label.text = "<";
			return;
		COND_TYPE.LESSEQ:
			cond_label.text = "<=";
			return;
		COND_TYPE.EQ:
			cond_label.text = "==";
			return;
		COND_TYPE.GREATEREQ:
			cond_label.text = ">=";
			return;
		COND_TYPE.GREATER:
			cond_label.text = ">";
			return;
		COND_TYPE.NOTEQ:
			cond_label.text = "!=";
			return;	
	
func Execute():
	var input1 = input_pins[0].get_value(true);
	var input2 = input_pins[1].get_value(true);
	
	var current_panel = null
	if (check_condition(input1, input2)):
		current_panel = nested_true_inflow_pin.connectedTo.get_value();
	else:
		current_panel = nested_false_inflow_pin.connectedTo.get_value();
		
	current_panel.Execute();
	
func check_condition(input1, input2) -> bool:
	match cond_type:
		COND_TYPE.LESS:
			return input1 < input2;
		COND_TYPE.LESSEQ:
			return input1 <= input2;
		COND_TYPE.EQ:
			return input1 == input2;
		COND_TYPE.GREATEREQ:
			return input1 >= input2;
		COND_TYPE.GREATER:
			return input1 > input2;
		COND_TYPE.NOTEQ:
			return input1 != input2;
	return false;


func nests_available() -> bool:
	return false;
	
func disconnect_nested_pins():
	for area in valid_areas:
		if(area.dropables.size() > 0):
			var panel = area.get_panel();
			panel.disconnect_all_pins();

func connect_nested_pins():
	disconnect_nested_pins();
	
	for i in range(valid_areas.size()):
		var area: NestedDropArea = valid_areas[i];
		var panel = area.get_panel();
		
		if panel:
			#True area
			if i == 0:
				nested_true_inflow_pin.connect_from_event(panel.inflow_pin, Vector2.LEFT, 1.0);
				nested_true_outflow_pin.connect_from_event(panel.outflow_pin, Vector2.LEFT, 1.0);
			#False area
			elif i == 1:
				nested_false_inflow_pin.connect_from_event(panel.inflow_pin, Vector2.LEFT, 1.0);
				nested_false_outflow_pin.connect_from_event(panel.outflow_pin, Vector2.LEFT, 1.0);
