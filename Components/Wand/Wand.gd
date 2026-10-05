class_name Wand extends Control
# Data container class for wand settings.

signal wand_selected(wand);

#Preload scenes.
var entry_scene = preload("res://Scenes/CodePanels/EntryPanel.tscn");
var exit_scene = preload("res://Scenes/CodePanels/ExitPanel.tscn");
var variable_scene = preload("res://Scenes/Wand/WandVariable.tscn");

#Vars
var is_entered: bool = false;
var parameter_map: Dictionary = {}; #name, value
var variable_map: Dictionary = {}; #name, value
var entry_panel: CodeEntryPanel = null;
var exit_panel: CodeExitPanel = null;
var code_panels: Array[CodePanel] = [];
var wand_variables: Array[Node] = [];

const entry_start_location: Vector2 = Vector2(600,400);
const exit_start_location: Vector2 = Vector2(1300,800);

@export var selection_root: Node = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered);
	mouse_exited.connect(_on_mouse_exited);
	
	if(!entry_panel):
		entry_panel = entry_scene.instantiate();
		entry_panel.position = entry_start_location;
	
	if(!exit_panel):
		exit_panel = exit_scene.instantiate();
		exit_panel.position = exit_start_location;
	
	entry_panel.set_parameters(parameter_map);
	
	create_variables();
	
	if selection_root:
		selection_root.hide();
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_buttons(event);
		
	if(Input.is_action_just_pressed("Run")):
		print(get_save_data());

func handle_mouse_buttons(event):					
	if(is_entered && event.is_action_released("Mouse1")):
		wand_selected.emit(self);
		
func _on_mouse_entered() -> void:
	is_entered = true;

func _on_mouse_exited() -> void:
	is_entered = false;
	
func add_parameter(name: String, value: Variant):
	parameter_map[name] = value;
	
func set_parameter_value(name: String, value: Variant):
	parameter_map.set(name, value);
	
func get_parameter_value(name: String):
	return parameter_map.get(name);
	
func get_parameter_count():
	return parameter_map.keys().size();
	
func add_variable(name: String, value: Variant):
	variable_map[name] = value;
	
func set_variable_value(name: String, value: Variant):
	variable_map.set(name, value);
	
func get_variable_value(name: String):
	return variable_map.get(name);
	
func get_variable_count():
	return variable_map.keys().size();
	
func add_listener_to_graph(graph: WandGraph):
	graph.panel_added.connect(on_panel_added);
	graph.panel_removed.connect(on_panel_removed);
	
func remove_listener_to_graph(graph: WandGraph):
	graph.panel_added.disconnect(on_panel_added);
	graph.panel_removed.disconnect(on_panel_removed);

func select_wand():
	entry_panel.show();
	exit_panel.show();
	
	for panel in code_panels:
		panel.show();
		
	if selection_root:
		selection_root.show();

func reset_wand():
	entry_panel.hide();
	exit_panel.hide();
	
	for panel in code_panels:
		panel.hide();
		
	if selection_root:
		selection_root.hide();
		
func on_panel_added(panel: CodePanel):
	code_panels.push_back(panel);
	
func on_panel_removed(panel: CodePanel):
	var rIndex = code_panels.find(panel);
	if(rIndex != -1):
		code_panels.remove_at(rIndex);

func create_variables():
	for variable in variable_map.keys():
		var new_var = variable_scene.instantiate() as WandVariable;
		new_var.init_wand_variable(self, variable);
		wand_variables.push_back(new_var);

func get_save_data():
	return {
		"parameters": parameter_map,
		"variables": variable_map,
		"entry_panel": entry_panel.get_save_data(),
		"exit_panel": exit_panel.get_save_data(),
		"panels": get_panel_data(),
	}

func get_panel_data():
	var data = [];
	
	for panel in code_panels:
		data.push_back(panel.get_save_data());
		
	return data;
	
func init_with_data(data: Dictionary):
	var params = data["parameters"];
	
	for param in params.keys():
		add_parameter(param, params[param]);
	
	var vars = data["variables"];
	
	for vari in vars:
		add_variable(vari, vars[vari]);
		
	var entry_data = data["entry_panel"];
	var entry = load(entry_data["scene"]);
	entry_panel = entry.instantiate();
	entry_panel.init_panel(entry_data);
	
	var exit_data = data["exit_panel"];
	var exit = load(exit_data["scene"]);
	exit_panel = exit.instantiate();
	exit_panel.init_panel(exit_data);
	
	var panels = data["panels"];
	for panel in panels:
		var panel_scene = load(panel["scene"]);
		var new_panel = panel_scene.instantiate();
		code_panels.push_back(new_panel);
		new_panel.init_panel(panel);
