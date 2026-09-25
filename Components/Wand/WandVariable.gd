class_name WandVariable extends PanelContainer

signal set_created(variable, panel);
signal get_created(variable, panel);

var set_panel_scene = preload("res://Scenes/CodePanels/SetVariablePanel.tscn");
var get_panel_scene = preload("res://Scenes/CodePanels/GetVariablePanel.tscn");

@export var create_set_button: Button = null;
@export var create_get_button: Button = null;
@export var variable_name_label: Label = null;

var wand: Wand;
var var_name: String;
var wand_graph: WandGraph;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_set_button.button_up.connect(create_set);
	create_get_button.button_up.connect(create_get);
	
func init_wand_variable(w: Wand, variable: String):
	wand = w;
	var_name = variable;
	variable_name_label.text = var_name;
	#wand_graph = graph;
	
func create_set():
	var new_set = set_panel_scene.instantiate();
	
	#TODO this might want to just send the panel with the right data set.
	set_created.emit(self, new_set);
	
func create_get():
	var new_get = get_panel_scene.instantiate();
	
	#TODO this might want to just send the panel with the right data set.
	get_created.emit(self, new_get);
