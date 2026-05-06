extends AnimatedSprite2D

#var DefaultColor = Color.WHITE;
var data_type = null;
var CorrectColor = Color(0,128,0)
var IncorrectColor = Color(128,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("pin_hover", play_hover)
	get_parent().connect("pin_hover_correct", play_correct)
	get_parent().connect("pin_hover_incorrect", play_incorrect)
	get_parent().connect("pin_connected", set_connected)
	get_parent().connect("pin_reset", set_reset)
	var parent = get_parent();
	data_type = (get_parent() as Pin).data_type;

func play_hover():
	if(animation != "Hover"):
		play("Hover");
		set_default_color();

func set_default_color():
	match data_type:
			Pin.DATA_TYPE.NUMBER:
				modulate = Pin.NUMBER_COLOR;
			Pin.DATA_TYPE.STRING:
				modulate = Pin.STRING_COLOR;
			Pin.DATA_TYPE.CONTROL:
				modulate = Pin.CONTROL_COLOR;

func play_correct():
	play("Hover");
	modulate = CorrectColor;

func play_incorrect():
	play("Hover");
	modulate = IncorrectColor
	
func set_connected():
	play("Connected");
	set_default_color();
	
func set_reset():
	play("Idle");
	set_default_color();
