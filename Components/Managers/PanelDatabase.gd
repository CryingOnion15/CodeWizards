extends Node

var cards: Dictionary

func _ready() -> void:
	#TODO eventually turn this into a user:// file for saving.
	if not FileAccess.file_exists("res://Data/card_database.json"):
		return;
	
	var file = FileAccess.open("res://Data/card_database.json", FileAccess.READ);
	
	#parse the file
	var json_str = file.get_as_text();
	var json = JSON.new();
	var error = json.parse(json_str);
	
	if error != OK:
		return;
		
	cards = json.data["cards"];
	
func get_card(id: String):
	return cards[id];
