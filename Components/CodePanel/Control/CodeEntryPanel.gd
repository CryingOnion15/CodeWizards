class_name CodeEntryPanel extends CodePanel

var startPin: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	
	startPin = availablePins[0];
	print(startPin.name)
	#TODO add support for parameters in the Entry Panel.
	# Idea is that all of the parameters passed to this wand,
	# are added as pins to drag out to.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func Execute():
	print("Started");
	# TODO Set starting pin values.
	
func get_next_control() -> CodePanel:
	if(startPin.connectedTo):
		return startPin.connectedTo.get_value();
	return null;
