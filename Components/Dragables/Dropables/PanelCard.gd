class_name PanelCard extends Dropable

var drop_panel: CodePanel = null;
var nested_area: NestedDropArea = null;
var template_id: String = "";
var tex_rect: TextureRect = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	drop_type = drop_type | DropData.DropType.GRID;
	if not tex_rect:
		tex_rect = get_node("TextureRect");

func set_card_texture(tex: Texture):
	if not tex_rect:
		tex_rect = get_node("TextureRect");
	tex_rect.texture = tex;

func handle_start(event):
	super.handle_start(event);
	drop_panel.set_mouse_filter_rec(drop_panel,Control.MOUSE_FILTER_IGNORE);
	drop_panel.modulate.a = .5;
	CodePanel.clear_selection();
	
func handle_end(event):
	super.handle_end(event);
	drop_panel.set_mouse_filter_rec(drop_panel,Control.MOUSE_FILTER_STOP);
	drop_panel.modulate.a = 1;
	
func get_save_data():
	return {
		"template": template_id,
		"data": drop_panel.get_save_data(),
	}
	
func init_card(data: Dictionary):
	if not data.is_empty():
		template_id = data.get("template", "");
		
		if template_id == "":
			push_error("Cannot initialize a card with no template.");
			return;
			
		var panel = PanelDatabase.get_panel(template_id);
		var panel_scene = panel.get("panelPath", "");
		
		if panel_scene != "":
			drop_scene = load(panel_scene);
			init_code_panel(data.get("data", {}));
		else:
			push_error("Could not find panel that you are trying to instantiate.")

func init_code_panel(data):
	var new_panel: CodePanel = drop_scene.instantiate();
	
	drop_panel = new_panel;
	
	
	if(drop_panel):
		DropManager.add_dropable_to_pool(drop_panel);
		drop_panel.panel_card = self;
		data.set("template",template_id);
		drop_panel.set_meta_data(data);
		drop_panel.init_panel();
		
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
	drop_panel.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	
func _get_grid_data():
	return drop_panel;
	
func _get_nest_data():
	return drop_panel;

func update_valid(drop_area: DropArea):
	print("VALID");
	super.update_valid(drop_area);
		
	if nested_area && drop_area != nested_area:
		nested_area.reset_area();
		nested_area = null;
	
	match drop_area.type:
		DropData.DropType.GRID:
			drop_panel.reparent(drop_area);
			var offset = Vector2(1,0) * drop_panel.size.x / 2;
			drop_panel.position = drop_area.get_local_mouse_position() - offset;
			drag_node = drop_panel;
			position = start_position;
		#TODO for nesting.
		DropData.DropType.NEST:
			if(drop_panel.can_be_nested):
				drop_panel.reparent(drop_area);
				drop_panel.position = Vector2.ZERO;
				drag_node = null;
				nested_area = drop_area as NestedDropArea;
				nested_area.minimum_size_changed.emit();
				position = start_position;
		_:
			update_to_default_state();

func update_invalid(drop_area: DropArea):
	print("INVALID");
	super.update_invalid(drop_area);
	
	if nested_area:
		nested_area.reset_area();
		nested_area = null;
	
	drag_node = null;
	position = start_position;
	drop_panel.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	
func update_to_default_state():
	print("DEFAULT");
	super.update_to_default_state();
	
	if nested_area:
		nested_area.reset_area();
		nested_area = null;
	
	drag_node = self;
	drop_panel.reparent(self);
	DropManager.add_dropable_to_pool(drop_panel);
	position = get_parent().get_local_mouse_position() - (size / 2);
