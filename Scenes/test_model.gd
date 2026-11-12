extends Button

@export var wand_gen: WandGenerator = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_pressed);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_pressed():
	if wand_gen:
		wand_gen.generate_wand("Generate one wand with creator: Iffy. Respond with only the JSON object.");
