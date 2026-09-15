@tool
class_name DropArea extends Control

signal drop_success(dropable);
signal drop_cancel(dropable);

signal activate_area_sig(area);
signal deactivate_area_sig(area);

@export var type: DropData.DropType = DropData.DropType.GRID;

var currentDropable: Dropable
var dropLocation: Vector2

#func _get_minimum_size() -> Vector2:
	#var size = Vector2.ZERO;
#
	#for child in get_children():
		#if child is Control:
			#size = size.max(child.position + child.size);
#
	#return size;
	#
#func _notification(what: int) -> void:
	#match what:
		#NOTIFICATION_CHILD_ORDER_CHANGED:
			#update_size();
		#
#func update_size():
	#size = _get_minimum_size();

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
	if(current_gui == self):
		print("Current " + current_gui.name + " Drop: " + drop.name);
		
		#Verify location is on this area then do the drop action.
		if(get_viewport().gui_get_hovered_control() == self && !already_has_drop(drop)):
			if(type & drop.drop_type):
				print("<><> SUCCESS <><>");
				drop_success.emit(drop);
				drop.success(type);
			else:
				print("<><> CANCEL <><>");
				drop_cancel.emit(drop);
				drop.cancel();
	deactivate_area();
	
func already_has_drop(drop) -> bool:	
	return get_children().find(drop) != -1;

func activate_area():
	activate_area_sig.emit(self);
	
func deactivate_area():
	deactivate_area_sig.emit(self);
