class_name CodePanel extends Dropable

enum THEME_SIZE {
	SMALL = 0,
	MEDIUM = 1,
	LARGE = 2,
}

var availablePins: Array[Pin] = []
var save_data: Dictionary

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

func drag(delta):
	#position += delta;
	#position = position.round();
	super.drag(delta);
	
func Execute():
	pass
	
func get_next_control() -> CodePanel:
	return null;
	
func set_data(data: Dictionary):
	save_data = data;
	
func set_theme_size(size: THEME_SIZE):
	size_theme = size;
	set_size_via_theme();
