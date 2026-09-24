class_name WandVariable extends PanelContainer

var set_panel_scene = preload("res://Components/CodePanel/Basic/SetVariablePanel.gd");
var get_panel_scene = preload("res://Components/CodePanel/Basic/GetVariablePanel.gd");

@export var create_set_button: Button = null;
@export var create_get_button: Button = null;

var wand: Wand;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_set_button.button_up.connect(create_set);
	create_get_button.button_up.connect(create_get);
	
func init_wand_variable(wand: Wand, variable: String):
	pass;
	
func create_set():
	pass;
	
func create_get():
	pass;
