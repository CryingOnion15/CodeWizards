class_name DropArea extends Control

signal drop_success(dropable);
signal drop_cancel(dropable);
signal on_drop_removed(dropable);

signal activate_area_sig(area);
signal deactivate_area_sig(area);

@export var type: DropData.DropType = DropData.DropType.GRID;

var dropables: Array[Dropable];
var dropLocation: Vector2;
var meta_data: Dictionary = {};

var _id: String = "";
	
var id: String = "":
	get:
		if _id == "":
			_id = SaveDataUtility.get_UUID();
		return _id;
	set(value):
		_id = value;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(check_valid_dropable);
	DropManager.instance.drop_location_updated.connect(on_update_drop_pos);
	DropManager.instance.drop_event.connect(on_drop);
	
	init_area();

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
			if(type & drop.drop_type):
				drop_succeeded(drop);
			else:
				drop_canceled(drop);
		else:
			drop_canceled(drop);
	else:
		remove_dropable(drop);
				
	deactivate_area();

func remove_dropable(drop):
	if (already_has_drop(drop)):
		dropables.erase(drop);
		on_drop_removed.emit(drop);
		await get_tree().process_frame;	
		resize_area();

func already_has_drop(drop) -> bool:	
	return dropables.find(drop) != -1;

func activate_area():
	activate_area_sig.emit(self);
	
func deactivate_area():
	deactivate_area_sig.emit(self);
	
func drop_succeeded(drop: Dropable):
	dropables.push_back(drop.get_drop_data(type));
	print(drop_success.get_connections());
	print(
		"EMITTING AREA: ",
		name,
		" ID: ",
		get_instance_id()
	)
	drop_success.emit(drop);
	drop.success(type);
	
func drop_canceled(drop):
	drop_cancel.emit(drop);
	drop.cancel();

func can_drop()-> bool:
	return true;

func resize_area():
	pass;
	
func reset_area():
	pass;

func set_meta_data(data: Dictionary):
	meta_data = data;

func init_area():
	if not meta_data.is_empty():
		var save_id = meta_data.get("id");
		id = save_id if save_id else SaveDataUtility.get_UUID();	
