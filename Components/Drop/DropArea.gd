class_name DropArea extends Control

signal drop_success(dropable);
signal drop_cancel(dropable);

signal activate_area_sig(area);
signal deactivate_area_sig(area);

@export var type: DropData.DropType = DropData.DropType.GRID;

var dropables: Array[Dropable];
var dropLocation: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(check_valid_dropable);
	DropManager.instance.drop_location_updated.connect(on_update_drop_pos);
	DropManager.instance.drop_event.connect(on_drop);

func check_valid_dropable(drop: Dropable):	
	#TODO subscribe to the events if this is a valid droppable type.
	if(drop != null && drop.drop_type & type):
		activate_area();
	else:
		deactivate_area();

func on_update_drop_pos(pos: Vector2):
	dropLocation = pos;
	
func on_drop(drop: Dropable, drop_area: DropArea):	
	if(drop_area == self):
		print("Current " + drop_area.name + " Drop: " + drop.name);
		
		#Verify location is on this area then do the drop action.
		if(!already_has_drop(drop)):
			print(type);
			print(drop.drop_type);
			if(type & drop.drop_type):
				drop_succeeded(drop);
			else:
				drop_canceled(drop);
		else:
			drop_canceled(drop);
	else:
		if (already_has_drop(drop)):
			dropables.erase(drop);
				
	deactivate_area();
	
func already_has_drop(drop) -> bool:	
	return dropables.find(drop) != -1;

func activate_area():
	activate_area_sig.emit(self);
	
func deactivate_area():
	deactivate_area_sig.emit(self);
	
func drop_succeeded(drop: Dropable):
	print("<><> SUCCESS <><>");
	dropables.push_back(drop.get_drop_data(type));
	drop_success.emit(drop);
	drop.success(type);
	
func drop_canceled(drop):
	print("<><> CANCEL <><>");
	drop_cancel.emit(drop);
	drop.cancel();

func resize_area():
	pass;
	
func reset_area():
	pass;	
