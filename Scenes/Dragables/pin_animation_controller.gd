extends AnimatedSprite2D

var DefaultColor = Color.WHITE;
var CorrectColor = Color(0,128,0)
var IncorrectColor = Color(128,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("pin_hover", play_hover)
	get_parent().connect("pin_hover_correct", play_correct)
	get_parent().connect("pin_hover_incorrect", play_incorrect)
	get_parent().connect("pin_connected", set_connected)
	get_parent().connect("pin_reset", set_reset)
	pass # Replace with function body.

func play_hover():
	play("Hover");
	modulate = DefaultColor;

func play_correct():
	play("Hover");
	modulate = CorrectColor;

func play_incorrect():
	play("Hover");
	modulate = IncorrectColor
	
func set_connected():
	play("Connected");
	modulate = DefaultColor;
	
func set_reset():
	play("Idle");
	modulate = DefaultColor;
