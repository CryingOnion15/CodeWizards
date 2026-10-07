class_name NestedPanelUtility extends RefCounted

static var nests: Dictionary[String, NestedDropArea] = {};

static func register_nest(id: String, nest: NestedDropArea):
	nests.set(id, nest);

static func get_nest(id):
	return nests.get(id);
