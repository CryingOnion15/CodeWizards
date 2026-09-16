class_name NestedPanel extends FunctionPanel

@export var drop_areas: Array[DropArea] = [];

var nested_inflow_pins: Array[Pin] = [];
var nested_outflow_pins: Array[Pin] = [];

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
	for area: DropArea in drop_areas:
		area.drop_success.connect(on_drop_success.bind(area));

func on_drop_success(dropable: Dropable, area: DropArea):
	var panel: CodePanel = dropable.get_drop_data(area.type);
	panel.is_nested = true;
	panel.drop_type = nest_type;
	panel.drop_node.reparent(area);
	panel.start_position = Vector2.ZERO;
	panel.drop_node.position = Vector2.ZERO;
	
	if(dropable is PanelCard):
		DropManager.add_dropable_to_pool(dropable);
	#print("Dropable: " + dropable.name);
	#print("Area: " + area.name);
	pass;
	
#func update_valid(drop_area: DropArea):
	#position = start_position;
	#
	#match drop_area.type:
		#DropData.DropType.CARD:
			#print("CARD");
			#panel_card.drop_node.reparent(drop_area);
			#var offset = Vector2(1,0) * panel_card.drop_node.size.x / 2;
			#panel_card.drop_node.position = drop_area.get_local_mouse_position() - offset;
			#drag_node = panel_card.drop_node;
		##TODO for nesting.
		#DropData.DropType.NEST:
			#print("NEST");
			#drag_node = null;
			#drop_node.reparent(drop_area);
		#DropData.DropType.GRID:
			#print("GRID");
			#drop_node.reparent(drop_area);
			#drag_node = drop_node;
		#_:
			#update_to_default_state();
			#
#func update_to_default_state():
	#drag_node = null;
	#position = start_position;
	#
	#if panel_card:
		#panel_card.drop_node.reparent(self);
		#DropManager.add_dropable_to_pool(panel_card);
