class_name DropArea extends Control

signal drop_success(dropable)
signal drop_cancel(dropable)

@export() 
var type: DropData.DropType = DropData.DropType.GRID;

var currentDropable: Dropable
var dropLocation: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(check_valid_dropable);
	DropManager.instance.drop_location_updated.connect(on_update_drop_pos);
	DropManager.instance.drop_event.connect(on_drop);

func check_valid_dropable(drop: Dropable):
	currentDropable = drop;
	
	#TODO subscribe to the events if this is a valid droppable type.
	if(drop != null && drop.drop_type & type):
		activate_area();
	else:
		deactivate_area();

func on_update_drop_pos(pos: Vector2):
	dropLocation = pos;
	
func on_drop(drop: Dropable):	
	var current_gui = get_viewport().gui_get_hovered_control();
	print("Current " + current_gui.name);
	
	#Verify location is on this area then do the drop action.
	if(get_viewport().gui_get_hovered_control() == self):
		if(type & drop.drop_type):
			print("<><> SUCCESS <><>");
			drop_success.emit(drop);
			drop.success();
		else:
			print("<><> CANCEL <><>");
			drop_cancel.emit(drop);
			drop.cancel();
	deactivate_area();

func activate_area():
	pass
	
func deactivate_area():
	pass
