extends Node2D

@onready var sprite = $Sprite2D;

var activeDropable = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(on_dropable_updated);
	DropManager.instance.drop_location_updated.connect(on_location_updated);

func on_dropable_updated(dropable: Dropable):
	if(dropable != null):
		visible = true;
		activeDropable = dropable;
	else:
		sprite.texture = null;
		activeDropable = null;
		visible = false;

func on_location_updated(loc: Vector2):
	var hoveredControl = get_viewport().gui_get_hovered_control();
	
	if(hoveredControl is DropArea):
		if((hoveredControl as DropArea).type & activeDropable.drop_type):
			print("Correct Area");
		else:
			print("Incorrect Area");
	#else:
		#sprite.texture = activeDropable.default_texture; 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
