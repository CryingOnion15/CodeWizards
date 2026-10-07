class_name NestedPanel extends FunctionPanel

@export var drop_areas: Array[NestedDropArea] = [];

#var valid_areas: Array[NestedDropArea] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_nests();
	super._ready();
	#valid_areas = drop_areas.filter(func(area:NestedDropArea): return area.is_visible_in_tree());

func init_panel():
	super.init_panel();
	
	if not meta_data.is_empty():
		var drop_ids = meta_data.get("dropAreas");
		if drop_ids.size() > 0:
			for i in range(drop_areas.size()):
				drop_areas[i].id = drop_ids[i];
				NestedPanelUtility.register_nest(drop_ids[i], drop_areas[i]);

func handle_start(event):
	super.handle_start(event);
	drag_node = self;
	
func handle_end(event):
	super.handle_end(event);
	drag_node = null;
	
	for area in drop_areas:
		area.resize_area();	
	
func setup_nests():		
	for area: DropArea in drop_areas:
		area.drop_success.connect(on_drop_success.bind(area));
		area.on_drop_removed.connect(on_drop_removed);
		
		print(area.drop_success.get_connections());
		
		print(
			"CONNECTING AREA: ",
			area.name,
			" ID: ",
			area.get_instance_id()
		)

func on_drop_success(dropable: Dropable, area: DropArea):
	var panel: Node = dropable.get_drop_data(area.type);
		
	panel.reparent(area);
	panel.nested_under = area.id;
	panel.start_position = Vector2.ZERO;
	panel.position = Vector2.ZERO;
	
	connect_nested_pins();
	
	panel.wand_graph = wand_graph;
	
	if(dropable is PanelCard):
		DropManager.add_dropable_to_pool(dropable);

func on_drop_removed(drop: Dropable):
	# TODO check if I can remove reset_size from other calls.
	hide();
	await get_tree().process_frame;
	reset_size();
	show();
	connect_nested_pins();

func nests_available() -> bool:
	for area in drop_areas:
		if(area.dropables.size() > 0):
			return true;

	return false;
	
func get_save_data():
	var save_data = super.get_save_data();
	
	var new = {
		"dropAreas": get_drop_area_ids(),
	}
	
	save_data.merge(new);
	
	return save_data;
		

func get_drop_area_ids()-> Array[String]:
	var ids: Array[String] = [];
	
	for area in drop_areas:
		ids.push_back(area.id);
		
	return ids;

func disconnect_nested_pins():
	pass;

func connect_nested_pins():
	pass;
