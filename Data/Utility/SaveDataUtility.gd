class_name SaveDataUtility extends RefCounted

static var save_data: Dictionary;

## TODO not guarenteed to be unique yet, but I might store a reference not sure yet.
static func get_UUID() -> String:
	var crypto = Crypto.new();
	var bytes = crypto.generate_random_bytes(16);
	
	return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" % [
		bytes[0], bytes[1], bytes[2], bytes[3],
		bytes[4], bytes[5], bytes[6], bytes[7],
		bytes[8], bytes[9], bytes[10], bytes[11],
		bytes[12], bytes[13], bytes[14], bytes[15]
	];
	
static func add_or_update_wand(id: String, data: Dictionary):
	var wand_data = save_data["wands"].filter(func(wand): return wand["id"] == id);
	
	if wand_data.size() == 0:
		save_data["wands"].push_back(data);
	else:
		wand_data[0].merge(data, true);

static func load_data_from_file(file_path: String):
	if not FileAccess.file_exists(file_path):
		return
		
	var file = FileAccess.open(file_path, FileAccess.READ);
	var json = JSON.new();
	var error = json.parse(file.get_as_text());
	
	if error != OK:
		return;
	
	save_data.merge(json.data);
	
static func get_data(id: String):
	return save_data[id];

static func update_save_file():
	#TODO need to decide how I am going to store data. One file or many.
	if not FileAccess.file_exists("res://Data/wand_save.json"):
		return
		
	var file = FileAccess.open("res://Data/wand_save.json", FileAccess.WRITE);	
	file.store_string(JSON.stringify(save_data, "\t"));
	file.close();
