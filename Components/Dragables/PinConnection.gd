class_name PinConnection extends Control

static var LINE_POINT_COUNT = 2;

var curve: Curve2D = null;
#var curvePoints: Array[Vector2] = [];
var owner_pin: Pin = null;
var connector_pin: Pin = null;

@export var line: Line2D = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve = Curve2D.new();
	
	for i in range(LINE_POINT_COUNT):
		#curvePoints.append(Vector2(0,0));
		curve.add_point(Vector2.ZERO)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func draw() -> void:
	if(connector_pin):
		update_end(connector_pin.connection_node.get_global_rect().get_center());
	
	if(owner_pin):
		update_start(owner_pin.connection_node.get_global_rect().get_center());
		
	line.points = curve.get_baked_points();
		
func update_start(global_pos):
	curve.set_point_position(0, line.to_local(global_pos));
	curve.set_point_in(0, Vector2.LEFT * 50.0);
	
func update_end(global_pos):
	curve.set_point_position(1, line.to_local(global_pos));
	curve.set_point_out(1, Vector2.RIGHT * 50.0);
