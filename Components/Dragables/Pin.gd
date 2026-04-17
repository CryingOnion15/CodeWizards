@tool
class_name Pin extends Dragable

enum PIN_TYPE {
	RECIEVER = 0, # Can only have another pin be dropped on this pin to make a connection.
	CONNECTOR = 1, # Can only drag from this pin to another to make a connection
	BOTH = 2, # Can do both above.
}

enum DATA_TYPE {
	NUMBER,
	STRING,
	CONTROL
}

#signals
signal pin_enter(pin: Pin)
signal pin_exit(pin: Pin)
signal pin_hover()
signal pin_hover_correct()
signal pin_hover_incorrect()
signal pin_connected()
signal pin_reset()

#CONST
static var LINE_POINT_COUNT = 12;

# Properties
@export var pin_type: PIN_TYPE = PIN_TYPE.BOTH;
@export var data_type: DATA_TYPE = DATA_TYPE.NUMBER;

#On Ready Var
@onready var line: Line2D = $Line2D

# Variables
var curve: Curve2D = null
var curveStartPosition: Vector2 = Vector2.ZERO
var curveEndPosition: Vector2 = Vector2.ZERO
var curvePoints: Array[Vector2] = []
var isDrawingCurve: bool = false;
var isConnected = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Pin")
	curve = Curve2D.new();
	
	for i in range(LINE_POINT_COUNT):
		curvePoints.append(Vector2(0,0));
		
	reset();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(isDrawingCurve && line):
		line.points = curve.get_baked_points()
		
# Warning tool to ensure right components.
func _get_configuration_warnings():
	if not has_node("Line2D"):
		return ["This node requires a Line2D child to draw the line of the connection."]
	return []
		
func updateCurve():
	var localStart = line.to_local(curveStartPosition)
	var localEnd = line.to_local(curveEndPosition)
	curve.set_point_position(1, localEnd);
	
	var rotVector = Vector2(cos(transform.get_rotation()), sin(transform.get_rotation())) * 100.0
	curve.set_point_out(0, rotVector)
	curve.set_point_in(1, -rotVector)
	
func handle_start(event):
	if(pin_type != PIN_TYPE.RECIEVER):
		curveStartPosition = global_position;
		curveEndPosition = global_position;
		isDrawingCurve = true;
		
		#Set up curve
		curve.clear_points();
		curve.add_point(line.to_local(curveStartPosition));
		
		#var midpoint = (curveStartPosition + curveEndPosition) / 2;
		#curve.add_point(midpoint);
		curve.add_point(line.to_local(curveEndPosition));
		
		super.handle_start(event);	
	
func handle_end(event):
	var dragables = get_intersected_dragables_at_mouse();
	
	if(dragables.size() > 0):
		var next_dragable = dragables[dragables.size() - 1];
		
		#If the draggable is a pin
		if(next_dragable is Pin && check_valid_connection(next_dragable as Pin)):
			var otherPin = next_dragable as Pin;
			curveEndPosition = next_dragable.global_position;
			var localEnd = line.to_local(curveEndPosition)
			curve.set_point_position(1, localEnd);
	
			var rotVector = Vector2(cos(next_dragable.transform.get_rotation()), sin(next_dragable.transform.get_rotation())) * 100.0
			curve.set_point_in(1, rotVector)
			
			connected();
			otherPin.connected();
		else:
			clear_line();
			reset();
	else:
		clear_line();
		reset();
		
	super.handle_end(event)
	
func get_intersected_pins_at_mouse() -> Array[Pin]:
	#Test the intersection points.
	var pointParmeters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	pointParmeters.position = get_global_mouse_position()
	pointParmeters.collide_with_areas = true
	
	var objects_clicked = get_world_2d().direct_space_state.intersect_point(pointParmeters)
	
	if(objects_clicked.size() > 0):	
		var pins: Array[Pin] = []

		for obj in objects_clicked:
			if obj.collider is Pin:
				pins.append(obj.collider as Pin)

		pins.sort_custom(
			func(c1: Pin, c2: Pin):
				return c1.z_index < c2.z_index
		)

		return pins
	return []
	
func check_valid_connection(otherPin: Pin) -> bool:
	if(otherPin.pin_type != PIN_TYPE.CONNECTOR && data_type == otherPin.data_type):
		return true;
	else:
		return false;
		
func clear_line():
	isDrawingCurve = false;
	line.points = [];
	
func drag(newPos):
	super.drag(newPos);
	curveEndPosition = newPos;
	updateCurve();

func hover():
	pin_hover.emit()
	
func correct_connect_hover():
	pin_hover_correct.emit()
	
func incorrect_connect_hover():
	pin_hover_incorrect.emit()
	
func reset():
	isConnected = false;
	pin_reset.emit();
	
func connected():
	isConnected = true;
	pin_connected.emit();

func _mouse_enter() -> void:
	super._mouse_enter();
	pin_enter.emit(self);

func _mouse_exit() -> void:
	super._mouse_exit();
	pin_exit.emit(self);
