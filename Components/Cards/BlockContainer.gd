class_name BlockContainer extends Control

@onready var hBox = $HBoxContainer

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
			drop.sceneToCreate = panel;
			drop.set_data(cardData["data"]);
			
			#Load and set textures.
			var defaultTex: Texture = load(cardData["defaultTexture"]);
			var correctTex: Texture = load(cardData["correctTexture"]);
			var incorrectTex: Texture = load(cardData["incorrectTexture"]);
			
			if(rect && defaultTex):
				rect.texture = defaultTex;
			
			if(defaultTex):
				drop.default_texture = defaultTex;
			
			if(correctTex):
				drop.valid_drop_texture = correctTex;
				
			if(incorrectTex):
				drop.invalid_drop_texture = incorrectTex;
			
			add_block(drop);
		else:
			continue;
	
	DropManager.instance.dropable_updated.connect(check_ownership)

func add_block(dropable: Dropable):
	hBox.add_child(dropable);

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
	
	if found != -1:
		print("Test");
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
