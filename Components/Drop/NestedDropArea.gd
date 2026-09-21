@tool
class_name NestedDropArea extends DropArea

func _get_minimum_size() -> Vector2:
	var required_size := Vector2.ZERO

	for child in get_children():
		if child is Control:
			var child_end = child.position + child.get_combined_minimum_size()

			required_size.x = max(required_size.x, child_end.x)
			required_size.y = max(required_size.y, child_end.y)

	return custom_minimum_size if required_size == Vector2.ZERO else required_size;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
func on_drop(drop: Dropable, drop_area: DropArea):
	if(already_has_drop(drop) && drop_area != self):
		resize_area();
	
	super.on_drop(drop, drop_area);
	
func drop_succeeded(drop: Dropable):
	super.drop_succeeded(drop);
	resize_area();
	
func resize_area():
	print("RESET AREA");
	visible = false;
	await get_tree().process_frame;
	size = _get_minimum_size();
	visible = true;
	minimum_size_changed.emit();
	
func reset_area():
	resize_area();
	
func can_drop()-> bool:
	return dropables.size() == 0;

func get_panel()-> FunctionPanel:
	if(dropables.size() > 0):
		return dropables[0] as FunctionPanel;
	else:
		return null;
