extends HBoxContainer


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
			drop.sceneToCreate = panel;
			drop.set_data(cardData["data"]);
			add_child(drop);
		else:
			continue;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
