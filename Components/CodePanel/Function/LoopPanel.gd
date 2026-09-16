class_name LoopPanel extends NestedPanel

func _ready() -> void:
	drop_node = get_parent();
	super._ready();

func Execute():
	var input1 = input_pins[0].get_value(true);
	
	#TODO Need to add the nested portion of this.
	run_loop(input1);

func run_loop(input):
	
	#TODO need to implement nested.
	for i in range(input):
		pass;
