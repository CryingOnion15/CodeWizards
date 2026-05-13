class_name DropArea extends Control

signal drop_success(dropable)

@export var type: DropData.DropType = DropData.DropType.PANEL;

var currentDropable: Dropable
var dropLocation: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(check_valid_dropable);

func check_valid_dropable(drop: Dropable):
	currentDropable = drop;
	
	#TODO subscribe to the events if this is a valid droppable type.
	if(drop != null && drop.type == type):
		DropManager.instance.drop_location_updated.connect(on_update_drop_pos);
		DropManager.instance.drop_event.connect(on_drop);
		activate_area();
	else:
		deactivate_area();

func on_update_drop_pos(pos: Vector2):
	dropLocation = pos;
	
	#TODO fix valid and invalid drop events. Maybe move stuff here. This is kind implemented in MouseTracker
	
func on_drop(drop: Dropable):
	DropManager.instance.drop_location_updated.disconnect(on_update_drop_pos);
	DropManager.instance.drop_event.disconnect(on_drop);
	
	#Verify location is on this area then do the drop action.
	if(get_viewport().gui_get_hovered_control() == self):
		drop_action(drop);
		
	deactivate_area();

func drop_action(drop: Dropable):
	drop_success.emit(drop);

func activate_area():
	pass
	
func deactivate_area():
	pass
