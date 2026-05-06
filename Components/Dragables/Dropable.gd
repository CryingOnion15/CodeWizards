class_name Dropable extends Dragable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
func handle_start(event):
	super.handle_start(event);
	modulate.a = .5;	
	
func handle_end(event):
	super.handle_end(event);
	modulate.a = 1;
	
	var control = get_viewport().gui_get_hovered_control()
	if(control is WandGraph):
		#TODO this is where we can add panels.
		pass
	print(control)
	
func drag(newPos):
	drag_event.emit(oldPos, newPos);
	oldPos = newPos;
