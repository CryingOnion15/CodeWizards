class_name MathPanel extends FunctionPanel

enum MATH_FUNC {
	ADD,
	SUB,
	MULT,
	DIV,
	MOD,
	EXP
	#LOG???
}

@export var math_type: MATH_FUNC = MATH_FUNC.ADD;
@export var math_label: RichTextLabel;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
	match math_type:
		MATH_FUNC.ADD:
			math_label.text = "+";
			return;
		MATH_FUNC.SUB:
			math_label.text = "-";
			return;
		MATH_FUNC.MULT:
			math_label.text = "*";
			return;
		MATH_FUNC.DIV:
			math_label.text = "/";
			return;
		MATH_FUNC.MOD:
			math_label.text = "%";
			return;
		MATH_FUNC.EXP:
			math_label.text = "^";
			return;
	
func Execute():
	var input1 = input_pins[0].get_value(true);
	var input2 = input_pins[1].get_value(true);
	
	output_pins[0].set_value(get_math_result(input1, input2))
	
func get_math_result(input1, input2):
	match math_type:
		MATH_FUNC.ADD:
			return input1 + input2;
		MATH_FUNC.SUB:
			return input1 - input2;
		MATH_FUNC.MULT:
			return input1 * input2;
		MATH_FUNC.DIV:
			return input1 / input2;
		MATH_FUNC.MOD:
			return input1 % input2;
		MATH_FUNC.EXP:
			return input1 ** input2;
