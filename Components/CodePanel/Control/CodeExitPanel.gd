class_name CodeExitPanel extends CodePanel

# Signals
signal exit_called(params: Dictionary)

# Variables 
var exitPin: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	exitPin = availablePins[0];
	availablePins.remove_at(0);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func Execute():
	print("Exit");
	var params: Dictionary = Dictionary();
	for i in range(1, availablePins.size()):
		params[availablePins[i].name] = availablePins[i].get_value(true);
		
	exit_called.emit(params);
