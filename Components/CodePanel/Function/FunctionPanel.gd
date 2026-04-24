class_name FunctionPanel extends CodePanel

var inflow_pin: Pin = null
var outflow_pin: Pin = null
var input_pins: Array[Pin] = []
var output_pins: Array[Pin] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if($FlowPins):
		var in_pin = $FlowPins.get_child(0);
		inflow_pin = in_pin as Pin if in_pin is Pin else null;
		
		var out_pin = $FlowPins.get_child(1);
		outflow_pin = out_pin as Pin if out_pin is Pin else null;
	
	if($InputPins):
		for pin in $InputPins.get_children():
			if (pin is Pin):
				input_pins.push_back(pin as Pin);
			
		
	if($OutputPins):
		for pin in $OutputPins.get_children():
			if (pin is Pin):
				output_pins.push_back(pin as Pin);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
