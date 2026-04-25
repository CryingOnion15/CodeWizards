class_name CodePanel extends Dragable

var availablePins: Array[Pin] = []

func _ready():
	var children = get_children(true);
	for child in children:
		if(child is Pin):
			var pin = child as Pin;
			if(pin.data_type == Pin.DATA_TYPE.CONTROL):
				# Set this pin's value to it's code panel owner.
				pin.set_value(self);
			availablePins.push_back(child as Pin);
	
func drag(newPos):
	var difference = newPos - oldPos;
	global_position += difference;
	super.drag(newPos);
	
func Execute():
	pass
	
func get_next_control() -> CodePanel:
	return null;
