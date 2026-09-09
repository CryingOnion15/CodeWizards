extends Node2D

@onready var sprite = $Sprite2D;

var active_dropable: Dropable = null;
var current_control: Node = null;
var current_drop_area: DropArea = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(on_dropable_updated);
	DropManager.instance.drop_location_updated.connect(on_location_updated);

func on_dropable_updated(dropable: Dropable):
	if(dropable != null):
		visible = true;
		active_dropable = dropable;
		on_location_updated(Vector2.ZERO);
	else:
		sprite.texture = null;
		active_dropable = null;
		visible = false;

func on_location_updated(loc: Vector2):
	var hoveredControl = get_viewport().gui_get_hovered_control();
	
	# This might need to be removed I am not sure.
	if (!hoveredControl):
		active_dropable.update_to_default_state();
		return;
	
	#Only update the state when a new control is hovered.
	if(current_control != hoveredControl):
		current_control = hoveredControl;
		if(hoveredControl is DropArea):
			if(current_drop_area != hoveredControl):
				current_drop_area = hoveredControl as DropArea;
				var is_valid = (current_drop_area.type & active_dropable.drop_type) != 0;
				active_dropable.set_valid_state(is_valid, current_drop_area);
		else:
			current_drop_area = null;
			active_dropable.update_to_default_state();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
