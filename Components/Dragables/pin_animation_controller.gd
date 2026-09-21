extends AnimatedSprite2D

#var DefaultColor = Color.WHITE;
var data_type = null;
var CorrectColor = Color(0,128,0)
var IncorrectColor = Color(128,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("pin_hover", play_hover);
	get_parent().connect("pin_hover_correct", play_correct);
	get_parent().connect("pin_hover_incorrect", play_incorrect);
	get_parent().connect("pin_connected", set_connected);
	get_parent().connect("pin_reset", set_reset);
	data_type = (get_parent() as Pin).data_type;

func play_hover():
	if(animation != "Hover"):
		play("Hover");
		set_default_color();

func set_default_color():
	match data_type:
			Pin.DATA_TYPE.NUMBER:
				modulate = Color(Pin.NUMBER_COLOR, modulate.a);
			Pin.DATA_TYPE.STRING:
				modulate = Color(Pin.STRING_COLOR, modulate.a);
			Pin.DATA_TYPE.CONTROL:
				modulate = Color(Pin.CONTROL_COLOR, modulate.a);

func play_correct():
	play("Hover");
	modulate = Color(CorrectColor, modulate.a);

func play_incorrect():
	play("Hover");
	modulate = Color(IncorrectColor, modulate.a)
	
func set_connected():
	play("Connected");
	set_default_color();
	
func set_reset():
	play("Idle");
	set_default_color();
