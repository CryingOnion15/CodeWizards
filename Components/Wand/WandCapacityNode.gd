class_name WandCapacityNode extends Control

@export var inactive_sprite: Texture2D;
@export var active_sprite: Texture2D;
@export var trigger_frame: int = 16;

@onready var sprite: Sprite2D = $Sprite2D;
@onready var animator: AnimatedSprite2D = $Sprite2D/AnimatedSprite2D;

signal glow_trigger(node: WandCapacityNode);

var active: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = inactive_sprite;
	animator.stop();
	animator.frame_changed.connect(on_frame_changed);
	
func on_frame_changed():
	if animator.frame == trigger_frame:
		glow_trigger.emit(self);

func set_active():
	active = true;
	sprite.texture = active_sprite;
	
func set_inactive():
	active = false;
	sprite.texture = inactive_sprite;	

func play_glow():
	if active:
		animator.play();
	
func stop_glow():
	animator.stop();
