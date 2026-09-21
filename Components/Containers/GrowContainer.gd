@tool
class_name GrowContainer extends Container


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		grow_to_children();
		
func grow_to_children() -> void:
	size = _get_minimum_size();

func _get_minimum_size() -> Vector2:
	var required_size := Vector2.ZERO

	for child in get_children():
		if child is Control:
			var child_end: Vector2 = child.position + child.get_combined_minimum_size();
			required_size.x = max(required_size.x, child_end.x)
			required_size.y = max(required_size.y, child_end.y)

	return required_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
