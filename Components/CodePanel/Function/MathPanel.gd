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
	print("READY: ", size);
	super._ready();
	
	#hide();
	#size = custom_minimum_size;
	#await get_tree().process_frame;
	
	update_minimum_size();
	
	print("READY 2: ", size)
	if math_label:
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
			
func get_save_data():
	var save_data = super.get_save_data();
	
	var new = {
		"type": math_type,
	}
	
	save_data.merge(new);
	return save_data;
	
func init_panel():
	super.init_panel();
	
	if not meta_data.is_empty():
		math_type = meta_data.get("type", MATH_FUNC.ADD);

#func _notification(what: int) -> void:
	#if what == NOTIFICATION_RESIZED:
		#print("RESIZED: ", size)
	
func Execute():
	print("Math Panel Woo.");
	output_pins[0].set_value("%s:%s" % [id, "get_math_result"])
	
func get_math_result():
	var input1 = input_pins[0].get_value(true);
	var input2 = input_pins[1].get_value(true);
	
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
