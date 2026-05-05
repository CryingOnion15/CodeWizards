class_name WandGraph extends Dragable

@export_range(1, 5, 0.1) var xBoundScale = 2;
@export_range(1, 5, 0.1) var yBoundScale = 2;

#Scene References
var entryScene = preload("res://Scenes/CodePanels/EntryPanel.tscn");
var exitScene = preload("res://Scenes/CodePanels/ExitPanel.tscn");

var entryPanel: CodeEntryPanel = null;
var exitPanel: CodeExitPanel = null;
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
	add_panel_to_graph(exitScene.instantiate(), size * .25 + parentSize * .9);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
		if(entryPanel != null && panel is CodeEntryPanel):
			entryPanel = panel;
		elif(exitPanel != null && panel is CodeExitPanel):
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
			
