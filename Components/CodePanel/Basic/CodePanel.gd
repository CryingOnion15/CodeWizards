class_name CodePanel extends Dragable

var availablePins: Array[Pin] = []

func _ready():
	super._ready();
	var children = find_children("*", "Pin", true, false);
	for child in children:
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
