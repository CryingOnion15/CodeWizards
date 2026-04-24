class_name VariablePanel extends CodePanel

@export var variable_number_value: int = 0;

var outputPin: Pin = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if($OutputPin is Pin):
		outputPin = $OutputPin as Pin;
		##DEBUG this only works with number values currently.
		outputPin.set_value(variable_number_value);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
