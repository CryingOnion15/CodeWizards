class_name CodePanel extends Dropable

enum THEME_SIZE {
	SMALL = 0,
	MEDIUM = 1,
	LARGE = 2,
}

@export var selection_root: Node = null;

var available_pins: Array[Pin] = [];
var panel_card: PanelCard = null;
var save_data: Dictionary;
var is_nested: bool = false;
var is_selected: bool = false;
var can_be_nested: bool = false;
var wand_graph: WandGraph = null;

#drop types.
var nest_type = DropData.DropType.GRID | DropData.DropType.CARD;
var normal_type = DropData.DropType.CARD;

static var selected_panel: CodePanel = null;
#@export var size_theme: THEME_SIZE = THEME_SIZE.MEDIUM;
#@export var pin_root: Node = self;

func _ready():
	super._ready();
	var children = find_children("*", "Pin", true, false);
	for child in children:
		var pin = child as Pin;
		if(pin.data_type == Pin.DATA_TYPE.CONTROL):
			# Set this pin's value to it's code panel owner.
			pin.set_value(func(): return self);
			
		available_pins.push_back(pin);
		
	#set_size_via_theme();
	unselect();
	
	#Dropable settings.
	drop_type = normal_type;
	drag_node = self;

func set_size_via_theme():
	var width = 0;
	var height = 0;
	
	#match(size_theme):
		#THEME_SIZE.SMALL:
			#width = get_theme_constant("small_width", "CodePanel");
			#height = get_theme_constant("small_height", "CodePanel");
			#pass
		#THEME_SIZE.MEDIUM:
			#width = get_theme_constant("medium_width", "CodePanel");
			#height = get_theme_constant("medium_height", "CodePanel");
			#pass
		#THEME_SIZE.LARGE:
			#width = get_theme_constant("large_width", "CodePanel");
			#height = get_theme_constant("large_height", "CodePanel");
			#pass
	
	custom_minimum_size = Vector2(width,height);	
	size = Vector2(width,height);
	
func Execute():
	pass;

func get_next_control() -> CodePanel:
	return null;
	
func set_data(data: Dictionary):
	save_data = data;
	
func set_theme_size(t_size: THEME_SIZE):
	pass;
	#size_theme = t_size;
	#set_size_via_theme();

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
		drag_node = self;
	
	if panel_card:
		panel_card.modulate.a = .5;
		panel_card.set_mouse_filter_rec(panel_card, MOUSE_FILTER_IGNORE);
	
	if CodePanel.selected_panel != self:	
		if CodePanel.selected_panel != null:
			CodePanel.selected_panel.unselect();
		
		CodePanel.selected_panel = self;
		select();
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	
	if panel_card:
		panel_card.modulate.a = 1;
		panel_card.set_mouse_filter_rec(panel_card, MOUSE_FILTER_STOP);
		
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
				panel_card.set_mouse_filter_rec(panel_card, MOUSE_FILTER_IGNORE);
		DropData.DropType.CARD:
			if panel_card:
				panel_card.modulate.a = 1;
				panel_card.set_mouse_filter_rec(panel_card, MOUSE_FILTER_STOP);
			remove_panel_from_graph();
			disconnect_all_pins();
		DropData.DropType.NEST:
			pass;
		DropData.DropType.RAM:
			pass;
		

func cancel():
	drop_cancel.emit();
	
	var current_control = get_viewport().gui_get_hovered_control();
	
	if current_control != current_parent:
		reparent(current_parent);
		position = start_position;
	
	if panel_card && panel_card:
		panel_card.reparent(self);
		DropManager.add_dropable_to_pool(panel_card);

func update_valid(drop_area: DropArea):
	super.update_valid(drop_area);
	
	match drop_area.type:
		DropData.DropType.CARD:
			if is_nested:
				reparent(current_parent);
				
			position = start_position;
			
			if panel_card:
				drag_node = panel_card;
				panel_card.reparent(drop_area);
				var offset = Vector2(1,1) * panel_card.size.x / 2;
				panel_card.position = drop_area.get_local_mouse_position() - offset;
			else:
				drag_node = null;

		DropData.DropType.NEST:
			drag_node = null;
			reparent(drop_area);
			position = Vector2.ZERO;
			drop_area.resize_area();
			
		DropData.DropType.GRID:
			if is_nested:
				reparent(drop_area);
				drag_node = self;
				var offset = Vector2(1,0) * size.x / 2;
				position = drop_area.get_local_mouse_position() - offset;
		_:
			update_to_default_state();

func update_invalid(drop_area: DropArea):
	super.update_valid(drop_area);
	
	if get_parent() != current_parent:
		reparent(current_parent);
	
	if !is_nested:
		drag_node = self;
	else:
		drag_node = null;
		position = Vector2.ZERO;
		drop_area.minimum_size_changed.emit();
	
	if panel_card:
		panel_card.reparent(self);
		DropManager.add_dropable_to_pool(panel_card);
	
func update_to_default_state():
	super.update_to_default_state();
	
	if get_parent() != current_parent:
		reparent(current_parent);

	if !is_nested:
		drag_node = self;
	else:
		drag_node = null;
		position = Vector2.ZERO;
		current_parent.minimum_size_changed.emit();

	if panel_card:
		panel_card.reparent(self);
		DropManager.add_dropable_to_pool(panel_card);

func disconnect_all_pins():
	for pin in available_pins:
		if(pin.connectedTo):
			pin.connectedTo.disconnect_pin();
		pin.disconnect_pin();

func select():
	print("SELECT");
	if selection_root:
		selection_root.show();
		
	is_selected = true;
	
func unselect():
	print("UNSELECT");
	if selection_root:
		selection_root.hide();
		
	is_selected = false;

static func clear_selection():
	if CodePanel.selected_panel:
		CodePanel.selected_panel.unselect();
		CodePanel.selected_panel = null;
		
func remove_panel_from_graph(): 
	if wand_graph:
		#TODO maybe do a signal here. Not sure. Look into better solution.
		var parent = get_parent();
		if parent is DropArea:
			parent.remove_dropable(self);
			
		wand_graph.remove_panel_from_graph(self);
		DropManager.add_dropable_to_pool(self);
		wand_graph = null;
		
