class_name PanelCard extends Dropable

@export var drop_scene: PackedScene = null;

var drop_panel: CodePanel = null;
var nested_area: NestedDropArea = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	drop_type = drop_type | DropData.DropType.GRID;
	
func handle_start(event):
	super.handle_start(event);
	drop_panel.set_mouse_filter_rec(drop_panel.drop_node,Control.MOUSE_FILTER_IGNORE);
	drop_panel.drop_node.modulate.a = .5;
	
func handle_end(event):
	super.handle_end(event);
	drop_panel.set_mouse_filter_rec(drop_panel.drop_node,Control.MOUSE_FILTER_STOP);
	drop_panel.drop_node.modulate.a = 1;

func init_drop():
	var new_panel = drop_scene.instantiate();
	
	if new_panel is CodePanel:
		drop_panel = new_panel;
	else:
		var panels = new_panel.find_children("*", "CodePanel", true, false);
		if panels.size() > 0:
			drop_panel = panels[0];
		else:
			drop_panel = null;
	
	if(drop_panel):
		DropManager.add_dropable_to_pool(drop_panel);
		drop_panel.panel_card = self;
		
		drop_panel.set_data(get_data());
		
		#If this panel can be nested then add the type.
		if drop_panel.can_be_nested:
			drop_type = drop_type | DropData.DropType.NEST;

func success(dropType: DropData.DropType):
	match dropType:
		DropData.DropType.NEST:
			DropManager.add_dropable_to_pool(self);
			if(drop_panel is FunctionPanel):
				drop_panel.nest_panel();
		DropData.DropType.GRID:
			DropManager.add_dropable_to_pool(self);
		DropData.DropType.CARD:
			pass;
		DropData.DropType.RAM:
			pass;
	
	super.success(dropType);

func cancel():
	super.cancel();
	drop_panel.drop_node.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	
func _get_grid_data():
	return drop_panel;
	
func _get_nest_data():
	return drop_panel;

func update_valid(drop_area: DropArea):
	super.update_valid(drop_area);
		
	if nested_area && drop_area != nested_area:
		nested_area.reset_area();
		nested_area = null;
	
	match drop_area.type:
		DropData.DropType.GRID:
			drop_panel.drop_node.reparent(drop_area);
			var offset = Vector2(1,0) * drop_panel.drop_node.size.x / 2;
			drop_panel.drop_node.position = drop_area.get_local_mouse_position() - offset;
			drag_node = drop_panel.drop_node;
			drop_node.position = start_position;
		#TODO for nesting.
		DropData.DropType.NEST:
			if(drop_panel.can_be_nested):
				drop_panel.drop_node.reparent(drop_area);
				drop_panel.drop_node.position = Vector2.ZERO;
				drag_node = null;
				nested_area = drop_area as NestedDropArea;
				nested_area.minimum_size_changed.emit();
				drop_node.position = start_position;
		_:
			update_to_default_state();

func update_invalid(drop_area: DropArea):
	super.update_invalid(drop_area);
	
	if nested_area:
		nested_area.reset_area();
		nested_area = null;
	
	drag_node = null;
	position = start_position;
	drop_panel.drop_node.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	
func update_to_default_state():
	super.update_to_default_state();
	
	if nested_area:
		nested_area.reset_area();
		nested_area = null;
	
	drag_node = self;
	drop_panel.drop_node.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	position = get_parent().get_local_mouse_position() - (size / 2);
