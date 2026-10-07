class_name WandGraph extends Dragable

signal panel_added(panel);
signal panel_removed(panel);

@export_range(1, 5, 0.1) var xBoundScale = 2;
@export_range(1, 5, 0.1) var yBoundScale = 2;
@export var drop_area: DropArea = null;
#@export var graph_settings: GraphSettings = null;

#Scene References
#var entryScene = preload("res://Scenes/CodePanels/EntryPanel.tscn");
#var exitScene = preload("res://Scenes/CodePanels/ExitPanel.tscn");

# Other Vars
var entryPanel: CodeEntryPanel = null;
var exitPanel: CodeExitPanel = null;
var currentPanel: CodePanel = null;
var panels: Array[CodePanel] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	anchor_left = 0;
	anchor_top = 0;
	anchor_right = xBoundScale;
	anchor_bottom = xBoundScale;

	visibility_changed.connect(resize_graph);
	
	#add_panel_to_graph(entryScene.instantiate(), size * .25 + parentSize * .1);
	#add_panel_to_graph(exitScene.instantiate(), size * .25 + parentSize * .75);
	
	#Subscribe to signals.
	drop_area.connect("drop_success", on_drop_success);
	#graph_settings.large_pressed.connect(func(): set_size_of_panels(CodePanel.THEME_SIZE.LARGE));
	#graph_settings.medium_pressed.connect(func(): set_size_of_panels(CodePanel.THEME_SIZE.MEDIUM));
	#graph_settings.small_pressed.connect(func(): set_size_of_panels(CodePanel.THEME_SIZE.SMALL));
	
	DropManager.instance.dropable_updated.connect(on_dropable_updated);	

func handle_start(event):
	super.handle_start(event);
	CodePanel.clear_selection();

func _process(_delta: float) -> void:
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
	
func set_size_of_panels(t_size: CodePanel.THEME_SIZE):
	entryPanel.set_theme_size(t_size);
	exitPanel.set_theme_size(t_size);
	
	for panel in panels:
		panel.set_theme_size(t_size);
	
func add_panel_to_graph(panel: CodePanel):
	if(panel != null):
		panel.wand_graph = self;
		if(panel == entryPanel || panel == exitPanel):
			return;
			
		#TODO probably need some sort of signal for connections.
		if(entryPanel == null && panel is CodeEntryPanel):
			entryPanel = panel;
		elif(exitPanel == null && panel is CodeExitPanel):
			exitPanel = panel;
		else:
			panels.push_back(panel);
		
		if(!panel.is_nested):
			if(panel.get_parent() != drop_area):
				if(panel.get_parent()):
					panel.reparent(drop_area);
				else:
					drop_area.add_child(panel);
		
		panel_added.emit(panel);

func remove_panel_from_graph(panel: CodePanel):
	if(panel != null):
		var rIndex = panels.find(panel);
		if(rIndex != -1):
			panels.remove_at(rIndex);
		
		panel_removed.emit(panel);

func reset_graph():
	panels.clear();
	
	var parentSize = get_parent_control().get_rect().size;
	position =  -parentSize * .5;
	
func resize_graph():
	await get_tree().process_frame;
	if is_visible_in_tree():
		var parentSize = get_parent_control().get_rect().size;
	
		#Offset panel to center.
		position =  -parentSize * .5;

func on_drop_success(drop: Dropable):
	var newPanel: CodePanel = drop.get_drop_data(drop_area.type) as CodePanel;
	await get_tree().process_frame;
	newPanel.set_data(drop.get_data());
	var offset = Vector2(1,0) * newPanel.size.x / 2;
	
	add_panel_to_graph(newPanel);

func on_dropable_updated(dropable: Dropable):
	if dropable:
		drop_area.mouse_filter = Control.MOUSE_FILTER_STOP;
	else:
		drop_area.mouse_filter = Control.MOUSE_FILTER_PASS;
		
func get_view_center():
	var parent_size = get_parent().size / 2;
	
	return Vector2(parent_size.x - position.x, parent_size.y - position.y);
