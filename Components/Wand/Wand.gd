class_name Wand extends Control
# Data container class for wand settings.

signal wand_selected(wand);

#Preload scenes.
var entry_scene = preload("res://Scenes/CodePanels/EntryPanel.tscn");
var exit_scene = preload("res://Scenes/CodePanels/ExitPanel.tscn");

#Vars
var is_entered
var parameter_map: Dictionary = {}; #name, value
var variable_map: Dictionary = {}; #name, value
var entry_panel: CodeEntryPanel = null;
var exit_panel: CodeExitPanel = null;
var code_panels: Array[CodePanel] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered);
	mouse_exited.connect(_on_mouse_exited);
	
	entry_panel = entry_scene.instantiate().get_node("CodeEntryPanel");
	exit_panel = exit_scene.instantiate().get_node("CodeExitPanel");
	
	
	#TODO load parameters from save file and replace.
	add_parameter("Param1", 5);
	add_parameter("Type", "Poison");
	
	entry_panel.set_parameters(parameter_map);
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_buttons(event);

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
	entry_panel.drop_node.show();
	exit_panel.drop_node.show();
	
	for panel in code_panels:
		panel.drop_node.show();

func reset_wand():
	entry_panel.drop_node.hide();
	exit_panel.drop_node.hide();
	
	for panel in code_panels:
		panel.drop_node.hide();
		
func on_panel_added(panel: CodePanel):
	code_panels.push_back(panel);
	
func on_panel_removed(panel: CodePanel):
	var rIndex = code_panels.find(panel);
	if(rIndex != -1):
		code_panels.remove_at(rIndex);
