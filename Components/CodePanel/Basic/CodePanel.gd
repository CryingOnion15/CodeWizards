class_name CodePanel extends Dragable
	
func drag(newPos):
	var difference = newPos - oldPos;
	global_position += difference;
	super.drag(newPos);
	
func Execute():
	pass
