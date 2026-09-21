class_name LoopPanel extends NestedPanel

var nested_inflow_pin: Pin = null;
var nested_outflow_pin: Pin = null;

func _ready() -> void:
	super._ready();
	
	for pin in availablePins:
		if(nested_inflow_pin == null && pin.pin_type == Pin.PIN_TYPE.RECIEVER && pin.data_type == Pin.DATA_TYPE.CONTROL && pin.nested):
			nested_inflow_pin = pin;
			
		if(nested_outflow_pin == null && pin.pin_type == Pin.PIN_TYPE.CONNECTOR && pin.data_type == Pin.DATA_TYPE.CONTROL && pin.nested):
			nested_outflow_pin = pin;
			
		if(nested_outflow_pin != null && nested_inflow_pin != null):
			break;

func Execute():
	var i = input_pins[0].get_value(true);
	run_loop(i);

func run_loop(iterations):
	for i in range(iterations):
		print("Loop Panel Iteration: ", i);
		var current_panel = nested_inflow_pin.connectedTo.get_value();
		while (current_panel && current_panel != self):
			if(current_panel is FunctionPanel):
				current_panel.Execute();
				current_panel = current_panel.outflow_pin.connectedTo.get_value();
			else:
				push_error("Not functional panels was nested.");
				break;
	
func disconnect_nested_pins():
	for area in valid_areas:
		if(area.dropables.size() > 0):
			var panel = area.get_panel();
			panel.disconnect_all_pins();

func connect_nested_pins():
	disconnect_nested_pins();
	
	if nests_available():
		var first_in: Pin = null;
		var current_out: Pin = null;
		
		for area in valid_areas:
			if(area.dropables.size() > 0):
				var panel = area.get_panel();

				if !first_in:
					first_in = panel.inflow_pin
					nested_inflow_pin.connect_from_event(first_in, Vector2.LEFT, 1.0);

				if current_out:
					current_out.connect_from_event(panel.inflow_pin, Vector2.LEFT, 100.0);
					
				current_out = panel.outflow_pin;
				
		nested_outflow_pin.connect_from_event(current_out, Vector2.RIGHT, 1.0);
