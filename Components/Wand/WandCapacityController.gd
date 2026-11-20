class_name WandCapacityController extends Control

@export var begin_node: PackedScene
@export var middle_node: PackedScene
@export var end_node: PackedScene
@export var container: Control;
@export var start_timer: float = 5.0;
@export var loop_interval: float = 15.0;

const MAX_CAPACITY: int = 16;
var capacity_nodes: Array[WandCapacityNode] = [];
var current_wand_capacity: int;
var loop_running: bool = false;
var first_run: bool = true;
var current_time: float = 0.0;

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
	if loop_running:
		if first_run:
			if(current_time > start_timer):
				current_time = 0.0;
				first_run = false;
				trigger_first_animation();
		else:
			if(current_time > loop_interval):
				current_time = 0.0;
				trigger_first_animation();
				
		current_time += delta;
		
func start_animation_loop():
	for node in capacity_nodes:
		node.glow_trigger.connect(trigger_next_animation);
	
	current_time = 0;
	loop_running = true;
	
func stop_animation_loop():
	current_time = 0;
	loop_running = false;
	first_run = true;
	
	for node in capacity_nodes:
		node.stop_glow();
		
		if node.glow_trigger.is_connected(trigger_next_animation):
			node.glow_trigger.disconnect(trigger_next_animation);
	
func trigger_first_animation():
	capacity_nodes[0].play_glow();
	print("Trigger Start");
	
func trigger_next_animation(node: WandCapacityNode):
	var index = capacity_nodes.find(node) + 1;
	
	if index < current_wand_capacity - 1:
		capacity_nodes[index].play_glow();
		print("Trigger Next");
	else:
		capacity_nodes[capacity_nodes.size() - 1].play_glow();
		print("Trigger End");

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
