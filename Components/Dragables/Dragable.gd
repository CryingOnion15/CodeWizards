class_name Dragable extends Control

signal drag_event(oldPosition, newPosition)
signal start_drag(startPosition)
signal end_drag(endPosition)

#Control variables
var isDragging: bool = false;
var isEntered: bool = false;

#Drag variables
var oldPos: Vector2 = Vector2.ZERO;
var newPos: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered);
	mouse_exited.connect(_on_mouse_exited);
	gui_input.connect(_on_gui_input)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_buttons(event);
		
	elif isDragging && event is InputEventMouseMotion:
		drag(get_global_mouse_position());
		

func handle_mouse_buttons(event):
	if(isEntered && event.is_action_pressed("Mouse1")):
		handle_start(event)
					
	if(isDragging && event.is_action_released("Mouse1")):
		handle_end(event)
	

func _on_mouse_entered() -> void:
	isEntered = true;

func _on_mouse_exited() -> void:
	isEntered = false;
	
func handle_start(event):
	isDragging = true
	oldPos = get_global_mouse_position();
	start_drag.emit(get_global_mouse_position());	
	
func handle_end(event):
	isDragging = false
	end_drag.emit(get_global_mouse_position())
	
func drag(newPos):
	drag_event.emit(oldPos, newPos);
	oldPos = newPos;
	
