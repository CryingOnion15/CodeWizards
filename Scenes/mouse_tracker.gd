extends Node2D

#@onready var sprite = $Sprite2D;

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
		#sprite.texture = null;
		active_dropable = null;
		visible = false;

func on_location_updated(_loc: Vector2):
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
				reset_most_recent_drop_area();
				current_drop_area = hoveredControl as DropArea;
				if (current_drop_area):
					var is_valid = (current_drop_area.type & active_dropable.drop_type) != 0;
					is_valid = is_valid && current_drop_area.can_drop;
					
					if(!hoveredControl.already_has_drop(active_dropable)):
						active_dropable.set_valid_state(is_valid, current_drop_area);
					else:
						active_dropable.update_to_default_state();
		else:
			reset_most_recent_drop_area();
			current_drop_area = null;
			active_dropable.update_to_default_state();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position();
	
func reset_most_recent_drop_area():
	if current_drop_area:
		current_drop_area.reset_area();
