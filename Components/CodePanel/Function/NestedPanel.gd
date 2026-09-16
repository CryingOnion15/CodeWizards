class_name NestedPanel extends FunctionPanel


var nested_inflow_pins: Array[Pin] = [];
var nested_outflow_pins: Array[Pin] = [];
var drop_areas: Array[DropArea] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	setup_nests();
	
func handle_start(event):
	super.handle_start(event);
	drag_node = drop_node;
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	
func setup_nests():
	drop_areas.clear();
	var areas = find_children("*", "DropArea", true, false);
	
	for area: DropArea in areas:
		area.drop_success.connect(on_drop_success.bind(area));
		drop_areas.push_back(area);

func on_drop_success(dropable: Dropable, area: DropArea):
	var panel = dropable.get_drop_data(area.type);
	panel.drop_node.reparent(area);
	panel.position = Vector2.ZERO;
	
	if(dropable is PanelCard):
		DropManager.add_dropable_to_pool(dropable);
	print("Dropable: " + dropable.name);
	print("Area: " + area.name);
	pass;
