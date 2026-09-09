class_name Dropable extends Dragable

#Maybe need these?
signal drop_success
signal drop_cancel

var drop_type: int = 0;
var drag_node: Node;

# Data Vars
#var drop_node: Node = null;
var drop_data: Dictionary = {};
var current_parent: Node = null;
var start_position: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
func init_drop():
	pass;

func handle_start(event):
	super.handle_start(event);
	modulate.a = .5;
	current_parent = get_parent();
	start_position = position;	
	DropManager.set_dropable(self);

func handle_end(event):
	super.handle_end(event);
	modulate.a = 1;
	DropManager.drop();

func drag(delta):
	if(drag_node):
		drag_node.position += delta;
		drag_node.position = drag_node.position.round();
	super.drag(delta);
	DropManager.update_drop_location(delta);
	
func set_data(data: Dictionary):
	drop_data = data;
	
func get_data():
	return drop_data;

func success():
	drop_success.emit();
	
func cancel():
	reparent(current_parent);
	position = start_position;
	drop_cancel.emit();
	
func get_drop_data(drop_type: DropData.DropType):
	if(drop_type & drop_type):
		match drop_type:
			DropData.DropType.GRID:
				return _get_grid_data();
			DropData.DropType.NEST:
				return _get_nest_data();
			DropData.DropType.CARD:
				return _get_card_data();
			DropData.DropType.RAM:
				return _get_ram_data();
				
func set_valid_state(isValid: bool = false, drop_area: DropArea = null):
	if(isValid):
		update_valid(drop_area);
	else:
		update_invalid(drop_area);

func update_valid(drop_area: DropArea):
	pass;
	
func update_invalid(drop_area: DropArea):
	pass;
	
func update_to_default_state():
	pass;

func _get_grid_data():
	return null;
	
func _get_nest_data():
	return null;

func _get_card_data():
	return null;

func _get_ram_data():
	return null;
