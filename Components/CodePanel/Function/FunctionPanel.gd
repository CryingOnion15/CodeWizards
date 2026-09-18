class_name FunctionPanel extends CodePanel

var inflow_pin: Pin = null;
var outflow_pin: Pin = null;
var input_pins: Array[Pin] = [];
var output_pins: Array[Pin] = [];

var nested_in_connection: Pin = null;
var nested_out_connection: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Modify the drop types to account for nesting.
	normal_type = normal_type | DropData.DropType.NEST;
	nest_type = nest_type | DropData.DropType.NEST;
	
	super._ready();
	for pin in availablePins:
		if(inflow_pin == null && pin.pin_type == Pin.PIN_TYPE.RECIEVER && pin.data_type == Pin.DATA_TYPE.CONTROL && !pin.nested):
			inflow_pin = pin;
			
		if(outflow_pin == null && pin.pin_type == Pin.PIN_TYPE.CONNECTOR && pin.data_type == Pin.DATA_TYPE.CONTROL && !pin.nested):
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

func handle_start(event):
	super.handle_start(event);
	
	if is_nested:
		nested_in_connection = inflow_pin.connectedTo;
		nested_out_connection = outflow_pin.connectedTo;
		nested_in_connection.disconnect_pin();
		nested_out_connection.disconnect_pin();
		inflow_pin.disconnect_pin();
		outflow_pin.disconnect_pin();
		
func cancel():	
	super.cancel();
	
	# TODO update to handle reconnection.
	if is_nested:
		if nested_in_connection:
			nested_in_connection.connect_from_event(inflow_pin, Vector2.LEFT, 1.0);
			inflow_pin.set_locked_state(true);
		
		if nested_out_connection:
			nested_out_connection.connect_from_event(outflow_pin, Vector2.RIGHT, 1.0);
			outflow_pin.set_locked_state(true);
		
	
func handle_end(event):
	super.handle_end(event);

func get_next_control() -> CodePanel:
	if(outflow_pin.connectedTo):
		return outflow_pin.connectedTo.get_value();
	return null;

func disconnect_all_pins():
	for pin in availablePins:
		if(pin.connectedTo):
			pin.connectedTo.disconnect_pin();
		pin.disconnect_pin();
		
func success(drop_type: DropData.DropType):
	match drop_type:
		DropData.DropType.GRID:
			unnest_panel();
		DropData.DropType.CARD:
			unnest_panel();
		DropData.DropType.NEST:
			nest_panel();
		DropData.DropType.RAM:
			pass;
			
	super.success(drop_type);
			
func nest_panel():
	is_nested = true;
	inflow_pin.set_locked_state(true);
	outflow_pin.set_locked_state(true);
	drop_type = nest_type;
	
func unnest_panel():
	is_nested = false;
	inflow_pin.set_locked_state(false);
	outflow_pin.set_locked_state(false);
	drop_type = normal_type;
