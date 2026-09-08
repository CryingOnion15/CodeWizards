class_name PanelCard extends Dropable

@export var drop_scene: PackedScene = null;

var drop_panel: CodePanel = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	drop_type = DropData.DropType.GRID | DropData.DropType.NEST;
	
func init_drop():
	drop_panel = drop_scene.instantiate();
	self.add_child(drop_panel);
	drop_panel.position = DropManager.SCENE_GRAVEYARD;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _get_grid_data():
	return drop_panel;
	
func _get_nest_data():
	return drop_panel;
	
func drag(mouseDelta):
	super.drag(mouseDelta);
	
func update_valid(type: DropData.DropType):
	## TODO switch to match/switch
	if(type == DropData.DropType.GRID):
		drop_panel.position = get_local_mouse_position();
		drop_panel.modulate.a = .5;
		drop_panel.move_to_front();
		drag_node = drop_panel;
	else:
		drop_panel.position = DropManager.SCENE_GRAVEYARD;
		drag_node = null;
	pass;
	
func update_invalid(type: DropData.DropType):
	drop_panel.position = DropManager.SCENE_GRAVEYARD;
	drop_panel.modulate.a = 0;
	drag_node = null;
