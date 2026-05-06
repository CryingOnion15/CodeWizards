class_name Dropable extends Dragable

@export var default_texture: Texture = null;
@export var valid_drop_texture: Texture = null;
@export var invalid_drop_texture: Texture = null;

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
	#var control = get_viewport().gui_get_hovered_control()
	DropManager.drop();
	
func drag(newPos):
	super.drag(newPos);
	DropManager.update_drop_location(newPos);
