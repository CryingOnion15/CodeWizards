class_name PinConnection extends Control

static var LINE_POINT_COUNT = 2;
signal connection_hovered;
signal connection_clicked;

var curve: Curve2D = null;
var owner_pin: Pin = null;
var connector_pin: Pin = null;
var is_hovered: bool = false;

@export var line: Line2D = null;
@export var hit_width: float = 4.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve = Curve2D.new();
	
	for i in range(LINE_POINT_COUNT):
		#curvePoints.append(Vector2(0,0));
		curve.add_point(Vector2.ZERO)
		
func _process(delta: float) -> void:
	if connector_pin && owner_pin && !owner_pin.locked:
		var mouse_pos = line.get_local_mouse_position();
		var points = curve.get_baked_points();
		var hovered = false;
		
		for i in range(points.size() - 1):
			var distance = Geometry2D.get_closest_point_to_segment(
				mouse_pos,
				points[i], 
				points[i+1]
			).distance_to(mouse_pos);
			
			if distance <= hit_width:
				hovered = true;
				break;
		
		if hovered != is_hovered:
			is_hovered = hovered;
			
			if is_hovered:
				connection_hovered.emit();
				
				if owner_pin.alter_control:
					draw_red();
				else:
					draw_reset();
			else:
				draw_reset();
				
func _input(event: InputEvent) -> void:
	if connector_pin && owner_pin:
		if event.is_action("Alternate-Controls"):
			if event.is_pressed() && is_hovered:
				draw_red();
			else:
				draw_reset();
		
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if is_hovered && owner_pin.alter_control:
					is_hovered = false;
					connection_clicked.emit();
					get_viewport().set_input_as_handled();

func get_save_data():
	return {
		"owner": owner_pin.id,
		"connector": connector_pin.id,
	}
	
func draw_red():
	line.modulate = Color.RED;
	
func draw_reset():
	line.modulate = Color.WHITE;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func draw() -> void:
	if(connector_pin):
		update_end(connector_pin.connection_node.get_global_rect().get_center());
	
	if(owner_pin):
		update_start(owner_pin.connection_node.get_global_rect().get_center());
		
	line.points = curve.get_baked_points();
		
func update_start(global_pos):
	curve.set_point_position(0, line.to_local(global_pos));
	curve.set_point_out(0, Vector2.RIGHT * 50.0);
	
func update_end(global_pos):
	curve.set_point_position(1, line.to_local(global_pos));
	curve.set_point_in(1, Vector2.LEFT * 50.0);
