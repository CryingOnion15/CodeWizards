extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropManager.instance.dropable_updated.connect(on_dropable_updated);
	pass # Replace with function body.

func on_dropable_updated(dropable: Dropable):
	if(dropable != null):
		visible = true;
	else:
		visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
	pass
