class_name WandManager extends Control

@export var wand_root: Node = null;
@export var wand_var_root: Node = null;
@export var graph_root: Node = null;

var wands: Array[Wand] = [];
var wand_graph: WandGraph = null;
var current_wand: Wand = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO will eventually need to load wands via save data.
	
	var wand_children = wand_root.find_children("*", "Wand", true, false);
	for wand in wand_children:
		if wand is Wand:
			wands.push_back(wand);
			wand.wand_selected.connect(on_wand_selected);
			
			#TODO instantiate all wand variables.
			
	var graph_children = graph_root.find_children("*", "WandGraph", true, false);
	for graph in graph_children:
		if graph is WandGraph:
			wand_graph = graph;
			break;

func on_wand_selected(wand: Wand):
	if wand && wand != current_wand:
		if current_wand:
			current_wand.reset_wand();
			current_wand.remove_listener_to_graph(wand_graph);
			hide_wand_vars();
		
		wand_graph.reset_graph();
		current_wand = wand;
		
		# Add all existing panels.
		set_graph_panels();
		
		# Set variables.
		set_wand_variables();
		
		# Select wand and add listeners for panel events.
		current_wand.select_wand();
		current_wand.add_listener_to_graph(wand_graph);
	else:
		if current_wand:
			current_wand.reset_wand();
			current_wand.remove_listener_to_graph(wand_graph);
			current_wand = null;

		wand_graph.reset_graph();
		hide_wand_vars();
		
func set_graph_panels():
	wand_graph.add_panel_to_graph(current_wand.entry_panel);
	wand_graph.add_panel_to_graph(current_wand.exit_panel);
		
	for panel in current_wand.code_panels:
		wand_graph.add_panel_to_graph(panel);
		
func set_wand_variables():
	for w_var: WandVariable in current_wand.wand_variables:
		if w_var.get_parent() != wand_var_root:
			if(w_var.get_parent() != null):
				w_var.reparent(wand_var_root);
			else:
				wand_var_root.add_child(w_var);
		
		w_var.show();
		w_var.wand_graph = wand_graph;
		w_var.set_created.connect(on_set_created);
		w_var.get_created.connect(on_get_created);

func hide_wand_vars():
	for w_var in current_wand.wand_variables:
		w_var.hide();
		w_var.set_created.disconnect(on_set_created);
		w_var.get_created.disconnect(on_get_created);

func on_set_created(variable: WandVariable, panel: SetVariablePanel):
	#Note sure if this needs more or not.
	wand_graph.add_panel_to_graph(panel);
	
func on_get_created(variable: WandVariable, panel: GetVariablePanel):
	panel.set_wand_variable(variable.wand, variable.var_name);
	wand_graph.add_panel_to_graph(panel);
