class_name DropManager extends Node
 
signal dropable_updated(dropable: Dropable);
signal drop_location_updated(loc: Vector2);
signal drop_event(dropable: Dropable);

static var instance: DropManager = null;

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
		instance.drop_event.emit(get_current());
		instance.set_dropable(null);
