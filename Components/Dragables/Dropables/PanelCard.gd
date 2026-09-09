class_name PanelCard extends Dropable

@export var drop_scene: PackedScene = null;

var drop_panel: CodePanel = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	drop_type = DropData.DropType.GRID | DropData.DropType.NEST;
	print(drop_type);
	
func handle_start(event):
	drag_node = self;
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	drop_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	drop_panel.modulate.a = .5;
	
	super.handle_start(event);
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	mouse_filter = Control.MOUSE_FILTER_STOP;
	drop_panel.mouse_filter = Control.MOUSE_FILTER_STOP;
	drop_panel.modulate.a = 1;
	
func init_drop():
	drop_panel = drop_scene.instantiate();
	drop_panel.panel_card = self;
	self.add_child(drop_panel);
	DropManager.add_dropable_to_pool(drop_panel);

func success():
	super.success();
	DropManager.add_dropable_to_pool(self);

func cancel():
	super.cancel();
	drop_panel.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	
func _get_grid_data():
	return drop_panel;
	
func _get_nest_data():
	return drop_panel;

func update_valid(drop_area: DropArea):
	position = start_position;
	
	match drop_area.type:
		DropData.DropType.GRID:
			drop_panel.reparent(drop_area);
			var offset = Vector2(1,0) * drop_panel.size.x / 2;
			drop_panel.position = drop_area.get_local_mouse_position() - offset;
			drag_node = drop_panel;
		#TODO for nesting.
		DropData.DropType.NEST:
			pass;
		_:
			update_to_default_state();

func update_invalid(drop_area: DropArea):
	drag_node = self;
	position = get_parent().get_local_mouse_position() - (size / 2);
	drop_panel.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	
func update_to_default_state():
	drag_node = self;
	drop_panel.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	position = get_parent().get_local_mouse_position() - (size / 2);
