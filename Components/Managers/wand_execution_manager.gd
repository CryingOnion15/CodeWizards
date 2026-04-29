extends Node

var entryPanel: CodeEntryPanel = null;
var exitPanel: CodeExitPanel = null;
var currentPanel: CodePanel = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child in find_children("*", "CodePanel", true, false):
		if(child is CodeEntryPanel):
			entryPanel = child as CodeEntryPanel;
		elif(child is CodeExitPanel):
			exitPanel = child as CodeExitPanel;
			
		if(entryPanel != null && exitPanel != null):
			break;
			
	print(entryPanel.name);
	print(exitPanel.name);
	
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
		
