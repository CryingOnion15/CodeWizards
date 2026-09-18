class_name BlockContainer extends Control

@export var hBox: Node = null;
@export var drop_area: DropArea = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO eventually turn this into a user:// file for saving.
	if not FileAccess.file_exists("res://Data/test_hand.json"):
		return;
	
	var file = FileAccess.open("res://Data/test_hand.json", FileAccess.READ);
	
	#parse the file
	var json_str = file.get_as_text();
	var json = JSON.new();
	var error = json.parse(json_str);
	
	if error != OK:
		return;
		
	var data = json.data;
	
	for card in data["cards"]:
		var cardData = PanelDatabase.get_card(card);
		var dropable: PackedScene = load(cardData["dragPath"]) as PackedScene;
		var panel: PackedScene = load(cardData["panelPath"]) as PackedScene;
		
		if(dropable && panel):
			var drop: Dropable = dropable.instantiate() as Dropable;
			var rect: TextureRect = drop.get_node("TextureRect");
			drop.drop_scene = panel;
			drop.set_data(cardData["data"]);
			drop.init_drop();
			
			##Load and set textures.
			var cardTex: Texture = load(cardData["cardTexture"]);
			
			if(rect && cardTex):
				rect.texture = cardTex;
							
			add_block(drop);
			drop_area.dropables.push_back(drop);
		else:
			continue;
	
	DropManager.instance.dropable_updated.connect(check_ownership) #TODO this looks unused.
	drop_area.connect("drop_success", on_drop_success);

func add_block(dropable: Dropable):
	hBox.add_child(dropable.drop_node);

func remove_block(dropable: Dropable):
	var children = hBox.get_children();
	
	var found = children.find(dropable);
	
	if found != -1:
		dropable.queue_free();
		
func remove_block_at_index(index: int):
	hBox.get_child(index).queue_free();

func check_ownership(dropable):
	var children = hBox.get_children();
	
	var found = children.find(dropable);
	
	# Need to look into why this is here.
	if found != -1:
		print("Test");
		
func on_drop_success(drop: Dropable):
	var card = drop.get_drop_data(drop_area.type);
	
	if drop is FunctionPanel:
		drop.disconnect_all_pins();
		
	#TODO this is not full recursive. So that will need to be adjusted in the future.
	if drop is NestedPanel:
		# Get all nested panels and then disconned and add cards back to list.
		var nest = drop as NestedPanel;
		for area in nest.drop_areas:
			for dropable in area.dropables:
				var nest_card = dropable.get_drop_data(drop_area.type);
				
				if dropable is FunctionPanel:
					dropable.disconnect_all_pins();
					dropable.unnest_panel();
				
				nest_card.reparent(hBox);
				nest_card.set_mouse_filter_rec(nest_card.drop_node,Control.MOUSE_FILTER_STOP);
				DropManager.add_dropable_to_pool(dropable);
			
			area.dropables.clear();
			area.resize_area();
			
		nest.drop_node.size = nest.drop_node.custom_minimum_size;
	
	card.reparent(hBox);
	card.set_mouse_filter_rec(card.drop_node,Control.MOUSE_FILTER_STOP);
