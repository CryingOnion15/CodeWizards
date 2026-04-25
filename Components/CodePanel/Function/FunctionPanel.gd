class_name FunctionPanel extends CodePanel

var inflow_pin: Pin = null
var outflow_pin: Pin = null
var input_pins: Array[Pin] = []
var output_pins: Array[Pin] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	for pin in availablePins:
		if(inflow_pin != null && pin.pin_type == Pin.PIN_TYPE.RECIEVER && pin.data_type == Pin.DATA_TYPE.CONTROL):
			inflow_pin = pin;
			
		if(outflow_pin != null && pin.pin_type == Pin.PIN_TYPE.RECIEVER && pin.data_type == Pin.DATA_TYPE.CONTROL):
			outflow_pin = pin;
			
		if(outflow_pin != null && inflow_pin != null):
			break
	
	input_pins = availablePins.filter(
		func(pin):
			return pin.pin_type == Pin.PIN_TYPE.RECIEVER && pin.data_type != Pin.DATA_TYPE.CONTROL; 
	)
	output_pins = availablePins.filter(
		func(pin):
			return pin.pin_type == Pin.PIN_TYPE.CONNECTOR && pin.data_type != Pin.DATA_TYPE.CONTROL;
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
