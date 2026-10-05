extends Node

var cards: Dictionary
var panels: Dictionary

func _ready() -> void:
	#TODO eventually turn this into a user:// file for saving.
	if not FileAccess.file_exists("res://Data/card_database.json"):
		return;
	
	var card_db = FileAccess.open("res://Data/card_database.json", FileAccess.READ);
	
	if not FileAccess.file_exists("res://Data/panel_database.json"):
		return;
	
	var panel_db = FileAccess.open("res://Data/panel_database.json", FileAccess.READ)
	
	#parse the file
	var json_str = card_db.get_as_text();
	var json = JSON.new();
	var error = json.parse(json_str);
	
	if error != OK:
		return;
		
	cards = json.data["cards"];
	
	json_str = panel_db.get_as_text();
	error = json.parse(json_str);
	
	if error != OK:
		return;
		
	panels = json.data["panels"];
	
func get_card(id: String):
	return cards[id];
	
func get_panel(id: String):
	return panels[id];
