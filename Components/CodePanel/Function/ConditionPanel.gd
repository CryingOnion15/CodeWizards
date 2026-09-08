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
@export var cond_label: RichTextLabel;

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
	
	#TODO Need to add the nested portion of this.
	if (check_condition(input1, input2)):
		pass;
	else:
		pass;
	#output_pins[0].set_value(get_math_result(input1, input2))
	
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
