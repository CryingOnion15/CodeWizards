class_name CodePanel extends Dropable

enum THEME_SIZE {
	SMALL = 0,
	MEDIUM = 1,
	LARGE = 2,
}

var availablePins: Array[Pin] = [];
var panel_card: PanelCard = null;
var save_data: Dictionary;
var is_nested: bool = false;
var can_be_nested: bool = false;
#var nested_area: DropArea = null;

#drop types.
var nest_type = DropData.DropType.GRID | DropData.DropType.CARD;
var normal_type = DropData.DropType.CARD;

@export var size_theme: THEME_SIZE = THEME_SIZE.MEDIUM;
@export var pin_root: Node = self;

func _ready():
	super._ready();
	var children = pin_root.find_children("*", "Pin", true, false);
	for child in children:
		var pin = child as Pin;
		if(pin.data_type == Pin.DATA_TYPE.CONTROL):
			# Set this pin's value to it's code panel owner.
			pin.set_value(self);
		availablePins.push_back(child as Pin);
		
	set_size_via_theme();
	
	#Dropable settings.
	drop_type = normal_type;
	drag_node = drop_node;

func set_size_via_theme():
	var width = 0;
	var height = 0;
	
	match(size_theme):
		THEME_SIZE.SMALL:
			width = get_theme_constant("small_width", "CodePanel");
			height = get_theme_constant("small_height", "CodePanel");
			pass
		THEME_SIZE.MEDIUM:
			width = get_theme_constant("medium_width", "CodePanel");
			height = get_theme_constant("medium_height", "CodePanel");
			pass
		THEME_SIZE.LARGE:
			width = get_theme_constant("large_width", "CodePanel");
			height = get_theme_constant("large_height", "CodePanel");
			pass
	
	custom_minimum_size = Vector2(width,height);	
	size = Vector2(width,height);
	
func Execute():
	pass;

func get_next_control() -> CodePanel:
	return null;
	
func set_data(data: Dictionary):
	save_data = data;
	
func set_theme_size(t_size: THEME_SIZE):
	size_theme = t_size;
	set_size_via_theme();

func init_drop():
	pass;
	## TODO When data is linked I can set the card/block to the prefab.
	#drop_panel = drop_scene.instantiate();
	#drop_panel.panel_card = self;
	#self.add_child(drop_panel);
	#DropManager.add_dropable_to_pool(drop_panel);

func handle_start(event):
	super.handle_start(event);
	
	if !is_nested:
		drag_node = drop_node;
	
	if panel_card:
		panel_card.drop_node.modulate.a = .5;
		panel_card.set_mouse_filter_rec(panel_card.drop_node, MOUSE_FILTER_IGNORE);
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	
	if panel_card:
		panel_card.drop_node.modulate.a = 1;
		panel_card.set_mouse_filter_rec(panel_card.drop_node, MOUSE_FILTER_STOP);
	
	
func _get_nest_data():
	return self;

func _get_grid_data():
	return self;
	
func _get_card_data():
	return panel_card;

func success(drop_type: DropData.DropType):
	super.success(drop_type);
	
	match drop_type:
		DropData.DropType.GRID:
			if panel_card:
				panel_card.set_mouse_filter_rec(panel_card.drop_node, MOUSE_FILTER_IGNORE);
			#DropManager.add_dropable_to_pool(self);
		DropData.DropType.CARD:
			if panel_card:
				panel_card.drop_node.modulate.a = 1;
				panel_card.set_mouse_filter_rec(panel_card.drop_node, MOUSE_FILTER_STOP);
			DropManager.add_dropable_to_pool(self);
		DropData.DropType.NEST:
			if panel_card:
				panel_card.set_mouse_filter_rec(panel_card.drop_node, MOUSE_FILTER_IGNORE);
		DropData.DropType.RAM:
			pass;
		

func cancel():
	drop_cancel.emit();
	
	var current_control = get_viewport().gui_get_hovered_control();
	
	if current_control != current_parent:
		reparent(current_parent);
		position = start_position;
	
	if panel_card && panel_card.drop_node:
		panel_card.drop_node.reparent(self);
		DropManager.add_dropable_to_pool(panel_card.drop_node);

func update_valid(drop_area: DropArea):
	super.update_valid(drop_area);
	position = start_position;
	
	match drop_area.type:
		DropData.DropType.CARD:
			drop_node.position = start_position;
			drag_node = panel_card.drop_node;
			panel_card.drop_node.reparent(drop_area);
			var offset = Vector2(1,1) * panel_card.drop_node.size.x / 2;
			panel_card.drop_node.position = drop_area.get_local_mouse_position() - offset;

		DropData.DropType.NEST:
			drag_node = null;
			drop_node.reparent(drop_area);
			drop_node.position = Vector2.ZERO;
			drop_area.resize_area();
			
		DropData.DropType.GRID:
			print("GRID");
			if is_nested:
				drop_node.reparent(drop_area);
				drag_node = drop_node;
				
			var offset = Vector2(1,0) * drop_node.size.x / 2;
			drop_node.position = drop_area.get_local_mouse_position() - offset;
		_:
			update_to_default_state();

func update_invalid(drop_area: DropArea):
	super.update_valid(drop_area);
	
	if get_parent() != current_parent:
		drop_node.reparent(current_parent);
	
	if !is_nested:
		drag_node = drop_node;
		var offset = Vector2(1,0) * drop_node.size.x / 2;
		drop_node.position = drop_node.get_parent().get_local_mouse_position() - offset;
	else:
		drag_node = null;
		drop_node.position = Vector2.ZERO;
		drop_area.minimum_size_changed.emit();
	
	if panel_card:
		panel_card.drop_node.reparent(self);
		DropManager.add_dropable_to_pool(panel_card);
	
func update_to_default_state():
	super.update_to_default_state();
	
	if get_parent() != current_parent:
		drop_node.reparent(current_parent);

	if !is_nested:
		drag_node = drop_node;
		var offset = Vector2(1,0) * drop_node.size.x / 2;
		drop_node.position = drop_node.get_parent().get_local_mouse_position() - offset;
	else:
		drag_node = null;
		drop_node.position = Vector2.ZERO;
		current_parent.minimum_size_changed.emit();

	if panel_card:
		panel_card.drop_node.reparent(self);
		DropManager.add_dropable_to_pool(panel_card);
