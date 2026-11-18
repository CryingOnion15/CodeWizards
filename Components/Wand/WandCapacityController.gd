class_name WandCapacityController extends Control

@export var begin_node: PackedScene
@export var middle_node: PackedScene
@export var end_node: PackedScene
@export var container: Control;

const MAX_CAPACITY: int = 16;
var capacity_nodes: Array[WandCapacityNode] = [];
var current_wand_capacity: int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	capacity_nodes = [];
	
	for i in range(MAX_CAPACITY):
		var c_node
		if(i == 0):
			c_node = begin_node.instantiate() as WandCapacityNode;
		elif(i == MAX_CAPACITY - 1):
			c_node = end_node.instantiate() as WandCapacityNode;
		else:
			c_node = middle_node.instantiate() as WandCapacityNode;
			
		capacity_nodes.push_back(c_node);
		container.add_child(c_node);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_wand_capacity(wand_size):
	current_wand_capacity = wand_size;
	
	for c_node in capacity_nodes:
		#TODO remove animation subscriptions.
		c_node.hide();
	
	for i in range(wand_size - 1):
		#TODO add animation subscriptions.
		capacity_nodes[i].show();
	
	#TODO add animation subscriptions.
	capacity_nodes[MAX_CAPACITY - 1].show();
	
func set_active_capacity(filled_count: int):
	
	for i in range(current_wand_capacity - 1):
		if(i < filled_count):
			capacity_nodes[i].set_active();
		else:
			capacity_nodes[i].set_inactive();
	
	# Set the last node active if wand is full.
	if filled_count == current_wand_capacity:
		capacity_nodes[capacity_nodes.size() - 1].set_active();
	else:
		capacity_nodes[capacity_nodes.size() - 1].set_inactive();
