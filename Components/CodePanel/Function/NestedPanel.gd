class_name NestedPanel extends FunctionPanel

@export var drop_areas: Array[DropArea] = [];

var nested_inflow_pin: Pin = null;
var nested_outflow_pin: Pin = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	setup_nests();
	
	for pin in availablePins:
		if(nested_inflow_pin == null && pin.pin_type == Pin.PIN_TYPE.RECIEVER && pin.data_type == Pin.DATA_TYPE.CONTROL && pin.nested):
			nested_inflow_pin = pin;
			
		if(nested_outflow_pin == null && pin.pin_type == Pin.PIN_TYPE.CONNECTOR && pin.data_type == Pin.DATA_TYPE.CONTROL && pin.nested):
			nested_outflow_pin = pin;
			
		if(nested_outflow_pin != null && nested_inflow_pin != null):
			break;

func handle_start(event):
	super.handle_start(event);
	drag_node = drop_node;
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	
	for area in drop_areas:
		area.resize_area();	
	
func setup_nests():	
	for area: DropArea in drop_areas:
		area.drop_success.connect(on_drop_success.bind(area));

func on_drop_success(dropable: Dropable, area: DropArea):
	var panel: CodePanel = dropable.get_drop_data(area.type);
	
	if (panel is FunctionPanel):
		var function = panel as FunctionPanel;
		
		#TODO need to calculate this when we have the array of drop areas involved,
		# but for now this is fine.
		nested_inflow_pin.connect_from_event(panel.inflow_pin, Vector2.LEFT, 1.0);
		nested_outflow_pin.connect_from_event(panel.outflow_pin, Vector2.RIGHT, 1.0);
		
	panel.drop_node.reparent(area);
	panel.start_position = Vector2.ZERO;
	panel.drop_node.position = Vector2.ZERO;
	
	if(dropable is PanelCard):
		DropManager.add_dropable_to_pool(dropable);
