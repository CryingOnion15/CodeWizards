extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Dragable.connect("drag_event", drag_node)
	#$DragableNode2.connect("drag_event", drag_test)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func drag_node(oldPos, newPos) -> void:
	var difference = newPos - oldPos;
	global_position += difference;
