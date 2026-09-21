class_name DropManager extends Node
 
signal dropable_updated(dropable: Dropable);
signal drop_location_updated(loc: Vector2);
signal drop_event(dropable: Dropable, drop_area: DropArea);

static var instance: DropManager = null;
static var DROP_POOL: Vector2 = Vector2(5000, 5000);

var current_dropable: Dropable;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(instance == null):
		instance = self;
	else:
		queue_free();

static func set_dropable(dropable: Dropable):
	if(instance != null):
		instance.current_dropable = dropable;
		instance.dropable_updated.emit(instance.current_dropable);

static func get_current() -> Dropable:
	if(instance != null):
		return instance.current_dropable;
	return null;

static func update_drop_location(loc: Vector2):
	if(instance != null):
		instance.drop_location_updated.emit(loc);

static func drop():
	if(instance != null):
		
		var drop = get_current();
		
		if drop.valid_drop:
			var drop_area = instance.get_viewport().gui_get_hovered_control();
		
			if drop_area is DropArea:
				instance.drop_event.emit(get_current(), instance.get_viewport().gui_get_hovered_control() as DropArea);
		else:
			drop.cancel();
			
		DropManager.set_dropable(null);

static func add_dropable_to_pool(dropable: Dropable):
	dropable.drop_node.position = DROP_POOL;
	if(dropable.drop_node.get_parent()):
			dropable.drop_node.reparent(instance);
	else:
		instance.add_child(dropable.drop_node);
	
	
