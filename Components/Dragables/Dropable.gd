class_name Dropable extends Dragable


@export var type: DropData.DropType = DropData.DropType.PANEL;
@export var sceneToCreate: PackedScene = null;

@export_group("Drop Textures")
@export var default_texture: Texture = null;
@export var valid_drop_texture: Texture = null;
@export var invalid_drop_texture: Texture = null;

var drop_data: Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();

func handle_start(event):
	super.handle_start(event);
	modulate.a = .5;	
	DropManager.set_dropable(self);

func handle_end(event):
	super.handle_end(event);
	modulate.a = 1;
	DropManager.drop();

func drag(newPos):
	super.drag(newPos);
	DropManager.update_drop_location(newPos);
	
func set_data(data: Dictionary):
	drop_data = data;
	
func get_data():
	return drop_data;
