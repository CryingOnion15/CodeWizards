class_name WandManager extends Control

var wand_var_scene = preload("res://Scenes/Wand/WandVariable.tscn");

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
			#wand_graph.hide();
			break;

func on_wand_selected(wand: Wand):
	if wand && wand != current_wand:
		print("Show");
		if current_wand:
			current_wand.reset_wand();
			current_wand.remove_listener_to_graph(wand_graph);
		
		#wand_graph.show();
		wand_graph.reset_graph();

		current_wand = wand;
		
		#Add all existing panels.
		wand_graph.add_panel_to_graph(current_wand.entry_panel);
		wand_graph.add_panel_to_graph(current_wand.exit_panel);
		
		for panel in current_wand.code_panels:
			wand_graph.add_panel_to_graph(panel);
		
		#Select wand and add listeners for panel events.
		current_wand.select_wand();
		current_wand.add_listener_to_graph(wand_graph);
	else:
		if current_wand:
			current_wand.reset_wand();
			current_wand.remove_listener_to_graph(wand_graph);
			current_wand = null;
		#wand_graph.hide();
		wand_graph.reset_graph();
