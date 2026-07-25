class_name GraphSettings extends Control

signal small_pressed;
signal medium_pressed;
signal large_pressed;

#On ready
@onready var large_btn: Button = $Large;
@onready var medium_btn: Button = $Medium;
@onready var small_btn: Button = $Small;

func _ready() -> void:
	large_btn.pressed.connect(on_large_pressed);
	medium_btn.pressed.connect(on_medium_pressed);
	small_btn.pressed.connect(on_small_pressed);
	
func on_large_pressed():
	large_pressed.emit();
	
func on_medium_pressed():
	medium_pressed.emit();
	
func on_small_pressed():
	small_pressed.emit();
