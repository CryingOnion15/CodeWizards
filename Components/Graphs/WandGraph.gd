class_name WandGraph extends Dragable

@export_range(1, 5, 0.1) var xBoundScale = 2;
@export_range(1, 5, 0.1) var yBoundScale = 2;

# On Ready
@onready var drop_area = $DropArea;

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
	
	drop_area.connect("drop_success", on_drop_success);
	

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Run")):
		Run();

func Run():
	if(entryPanel):
		currentPanel = entryPanel;
		while(currentPanel != null):
			currentPanel.Execute();
			currentPanel = currentPanel.get_next_control();
			print(currentPanel);
	else:
		print("No Entry Point");
	
func drag(newPos):
	var difference = newPos - oldPos;
	position += difference;
	
	#Position Clamping
	var parent_size = get_parent().size;
	var diffX = size.x - parent_size.x;
	var diffY = size.y - parent_size.y
	
	position.x = clamp(position.x, -diffX - 10, 0 + 10);
	position.y = clamp(position.y, -diffY - 10, 0 + 10);
	super.drag(newPos);

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
		
		add_child(panel);
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
	var newPanel: CodePanel = drop.sceneToCreate.instantiate() as CodePanel;
	
	add_panel_to_graph(newPanel, get_local_mouse_position());
	
			
