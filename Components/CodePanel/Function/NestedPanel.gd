class_name NestedPanel extends FunctionPanel


@onready var drop_area: DropArea = $DropArea;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_area.connect("drop_success", on_drop_success);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_drop_success():
	pass;
