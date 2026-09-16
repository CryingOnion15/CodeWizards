class_name NestedDropArea extends DropArea


func _get_minimum_size() -> Vector2:
	var required_size := Vector2.ZERO

	for child in get_children():
		if child is Control:
			var child_end = child.position + child.get_combined_minimum_size()

			required_size.x = max(required_size.x, child_end.x)
			required_size.y = max(required_size.y, child_end.y)

	return required_size;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
func on_drop(drop: Dropable, drop_area: DropArea):
	if(already_has_drop(drop) && drop_area != self):
		if(drop is CodePanel && drop_area.type != DropData.DropType.NEST):
			var panel = drop as CodePanel;
			panel.is_nested = false;
			panel.drop_type = panel.normal_type;
			
		size = custom_minimum_size;
		minimum_size_changed.emit();
	
	super.on_drop(drop, drop_area);
	
func drop_succeeded(drop: Dropable):
	super.drop_succeeded(drop);
	size = _get_minimum_size();
	minimum_size_changed.emit();
