extends ColorRect
	
func _on_mouse_entered() -> void:
	color.a = .9

func _on_mouse_exited() -> void:
	color.a = .6;
