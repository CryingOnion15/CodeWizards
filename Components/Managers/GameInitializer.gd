extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveDataUtility.initialize();

#func _notification(what: int) -> void:
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#SaveDataUtility.update_save_file();
		#get_tree().quit();

func _exit_tree() -> void:
	SaveDataUtility.update_save_file();
