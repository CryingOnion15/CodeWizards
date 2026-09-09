class_name CodePanel extends Dropable

enum THEME_SIZE {
	SMALL = 0,
	MEDIUM = 1,
	LARGE = 2,
}

var availablePins: Array[Pin] = [];
var panel_card: PanelCard = null;
var save_data: Dictionary;

@export var size_theme: THEME_SIZE = THEME_SIZE.MEDIUM;

func _ready():
	super._ready();
	var children = find_children("*", "Pin", true, false);
	for child in children:
		var pin = child as Pin;
		if(pin.data_type == Pin.DATA_TYPE.CONTROL):
			# Set this pin's value to it's code panel owner.
			pin.set_value(self);
		availablePins.push_back(child as Pin);
		
	set_size_via_theme();
	
	#Dropable settings.
	drop_type = DropData.DropType.CARD | DropData.DropType.NEST;
	drag_node = self;

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
	
func set_theme_size(size: THEME_SIZE):
	size_theme = size;
	set_size_via_theme();

func init_drop():
	pass;
	## TODO When data is linked I can set the card/block to the prefab.
	#drop_panel = drop_scene.instantiate();
	#drop_panel.panel_card = self;
	#self.add_child(drop_panel);
	#DropManager.add_dropable_to_pool(drop_panel);

func handle_start(event):
	drag_node = self;
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	panel_card.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	panel_card.modulate.a = .5;
	
	super.handle_start(event);
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	mouse_filter = Control.MOUSE_FILTER_STOP;
	panel_card.mouse_filter = Control.MOUSE_FILTER_STOP;
	panel_card.modulate.a = 1;

func _get_nest_data():
	return self;
	
func _get_card_data():
	return panel_card;

func success():
	super.success();
	DropManager.add_dropable_to_pool(self);

func cancel():
	super.cancel();
	panel_card.reparent(self);
	DropManager.add_dropable_to_pool(panel_card);

func update_valid(drop_area: DropArea):
	position = start_position;
	
	match drop_area.type:
		DropData.DropType.CARD:
			panel_card.reparent(drop_area);
			var offset = Vector2(1,0) * panel_card.size.x / 2;
			panel_card.position = drop_area.get_local_mouse_position() - offset;
			drag_node = panel_card;
		#TODO for nesting.
		DropData.DropType.NEST:
			pass;
		_:
			update_to_default_state();

func update_invalid(drop_area: DropArea):
	drag_node = self;
	position = get_parent().get_local_mouse_position() - (size / 2);
	panel_card.reparent(self);
	DropManager.add_dropable_to_pool(panel_card);
	
func update_to_default_state():
	drag_node = self;
	panel_card.reparent(self);
	DropManager.add_dropable_to_pool(panel_card);
	position = get_parent().get_local_mouse_position() - (size / 2);
