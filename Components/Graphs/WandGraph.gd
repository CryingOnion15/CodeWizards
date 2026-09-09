class_name WandGraph extends Dragable

@export_range(1, 5, 0.1) var xBoundScale = 2;
@export_range(1, 5, 0.1) var yBoundScale = 2;

#@export var node_canvas: Node2D = null;
@export var drop_area: DropArea = null;
@export var graph_settings: GraphSettings = null;

#Scene References
var entryScene = preload("res://Scenes/CodePanels/EntryPanel.tscn");
var exitScene = preload("res://Scenes/CodePanels/ExitPanel.tscn");

# Other Vars
var entryPanel: CodeEntryPanel = null;
var exitPanel: CodeExitPanel = null;
var currentPanel: CodePanel = null;
var panels: Array[CodePanel] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	anchor_left = 0;
	anchor_top = 0;
	anchor_right = xBoundScale;
	anchor_bottom = xBoundScale;
	
	#Wait a frame so the ui is in the right place and right size.
	await get_tree().process_frame;
	var parent = get_parent();
	var parentSize = get_parent_control().get_rect().size
	
	#Offset panel to center.
	position =  -parentSize * .5;
	
	add_panel_to_graph(entryScene.instantiate(), size * .25 + parentSize * .1);
	add_panel_to_graph(exitScene.instantiate(), size * .25 + parentSize * .75);
	
	#Subscribe to signals.
	drop_area.connect("drop_success", on_drop_success);
	graph_settings.large_pressed.connect(func(): set_size_of_panels(CodePanel.THEME_SIZE.LARGE));
	graph_settings.medium_pressed.connect(func(): set_size_of_panels(CodePanel.THEME_SIZE.MEDIUM))
	graph_settings.small_pressed.connect(func(): set_size_of_panels(CodePanel.THEME_SIZE.SMALL))	

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Run")):
		Run();
			
func Run():
	if(entryPanel):
		currentPanel = entryPanel;
		while(currentPanel != null):
			currentPanel.Execute();
			currentPanel = currentPanel.get_next_control();
	else:
		print("No Entry Point");

func drag(delta):
	position += delta;
	position = position.round();
	
	#Position Clamping
	var parent_size = get_parent().size;
	var diffX = size.x - parent_size.x;
	var diffY = size.y - parent_size.y
	
	position.x = clamp(position.x, -diffX, 0);
	position.y = clamp(position.y, -diffY, 0);
	super.drag(delta);
	
func set_size_of_panels(size: CodePanel.THEME_SIZE):
	entryPanel.set_theme_size(size);
	exitPanel.set_theme_size(size);
	
	for panel in panels:
		panel.set_theme_size(size);
	
func add_panel_to_graph(panel: CodePanel, location: Vector2):
	if(panel != null):
		if(panel == entryPanel || panel == exitPanel):
			return;
			
		#TODO probably need some sort of signal for connections.
		if(entryPanel == null && panel is CodeEntryPanel):
			entryPanel = panel;
		elif(exitPanel == null && panel is CodeExitPanel):
			exitPanel = panel;
		else:
			panels.push_back(panel);
		
		if(panel.get_parent()):
			panel.reparent(drop_area);
		else:
			drop_area.add_child(panel);
		panel.position = location;

func remove_panel_from_graph(panel: CodePanel):
	if(panel != null):
		if(panel == entryPanel || panel == exitPanel):
			return;
		else:
			var rIndex = panels.find(panel);
			if(rIndex != -1):
				panels.remove_at(rIndex);

func on_drop_success(drop: Dropable):
	var newPanel: CodePanel = drop.get_drop_data(drop_area.type) as CodePanel;
	await get_tree().process_frame;
	newPanel.set_data(drop.get_data());
	var offset = Vector2(1,0) * newPanel.size.x / 2
	
	add_panel_to_graph(newPanel, get_local_mouse_position() - offset); 
