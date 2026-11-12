class_name WandDataUtility extends RefCounted

static var wands: Dictionary[String,Wand] = {}

static func register_wand(id: String, wand: Wand):
	wands.set(id, wand);

static func get_wand(id: String):
	return wands.get(id);
