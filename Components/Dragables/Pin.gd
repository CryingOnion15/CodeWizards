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

#stativ variables
static var LINE_POINT_COUNT = 12;
static var NUMBER_COLOR = Color('#008794');
static var STRING_COLOR = Color('#FFDA03');
static var CONTROL_COLOR = Color('#FEF9F3');

# Properties
@export var pin_type: PIN_TYPE = PIN_TYPE.BOTH;
@export var data_type: DATA_TYPE = DATA_TYPE.NUMBER;

#On Ready Var
@onready var line: Line2D = $Line2D

# Variables
var curve: Curve2D = null
var curvePoints: Array[Vector2] = []
var connectedTo: Pin = null;
var isDrawingCurve: bool = false;
var isConnected = false;

var _string_value = "";
var _number_value = 0;
var _control_value: CodePanel = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	add_to_group("Pin")
	curve = Curve2D.new();
	
	for i in range(LINE_POINT_COUNT):
		curvePoints.append(Vector2(0,0));
		
	reset();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return;
	if(isDrawingCurve && line):
		if(isConnected && connectedTo != null):
			var localEnd = line.to_local(connectedTo.global_position)
			curve.set_point_position(1, localEnd);
		
		curve.set_point_position(0, line.to_local(global_position));
		line.points = curve.get_baked_points()
		
# Warning tool to ensure right components.
func _get_configuration_warnings():
	return;
	if not has_node("Line2D"):
		return ["This node requires a Line2D child to draw the line of the connection."]
	return []
		
func update_curve_on_drag(newPos):
	return;
	var localEnd = line.to_local(newPos)
	curve.set_point_position(1, localEnd);
	
	#var rotVector = Vector2(cos(transform.get_rotation()), sin(transform.get_rotation())) * 100.0
	#curve.set_point_out(0, rotVector)
	#curve.set_point_in(1, -rotVector)
	
func handle_start(event):
	
	if(isConnected):
		if(connectedTo):
			connectedTo.disconnect_pin();
		disconnect_pin();
		hover();
	
	# TODO might want to remove the reciever if for UX.
	if(pin_type != PIN_TYPE.RECIEVER):
		connectedTo = null;
		isDrawingCurve = true;
		
		#Set up curve
		curve.clear_points();
		curve.add_point(line.to_local(global_position));
		
		#var midpoint = (curveStartPosition + curveEndPosition) / 2;
		#curve.add_point(midpoint);
		curve.add_point(line.to_local(global_position));
		
		super.handle_start(event);	
	
func handle_end(event):
	var dragables = get_intersected_dragables_at_mouse();
	
	if(dragables.size() > 0):
		var next_dragable = dragables[dragables.size() - 1];
		
		if(next_dragable == self):
			clear_line();
			isConnected = false;
			connectedTo = null;
			hover();		
		#If the draggable is a pin
		elif(next_dragable is Pin && check_valid_connection(next_dragable as Pin)):
			var otherPin = next_dragable as Pin;
			var localEnd = line.to_local(next_dragable.global_position);
			curve.set_point_position(1, localEnd);
	
			var rotVector = Vector2(cos(next_dragable.transform.get_rotation()), sin(next_dragable.transform.get_rotation())) * 100.0
			curve.set_point_in(1, rotVector)
			
			connect_to_pin(otherPin);
			otherPin.connect_to_pin(self);
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
	update_curve_on_drag(newPos);

func hover():
	pin_hover.emit()
	
func correct_connect_hover():
	pin_hover_correct.emit()
	
func incorrect_connect_hover():
	pin_hover_incorrect.emit()
	
func reset():
	isConnected = false;
	connectedTo = null;
	pin_reset.emit();
	
func disconnect_pin():
	clear_line();
	reset();
	
func connect_to_pin(pin: Pin):
	#Is already connected to another pin.
	if(isConnected && connectedTo != null):
		connectedTo.disconnect_pin();
		disconnect_pin();
	
	isConnected = true;
	connectedTo = pin;
	pin_connected.emit();
	
func emit_connected():
	pin_connected.emit();

func _on_mouse_entered() -> void:
	super._on_mouse_entered();
	pin_enter.emit(self);

func _on_mouse_exited() -> void:
	super._on_mouse_exited();
	pin_exit.emit(self);
	
func get_value(get_value_from_connection: bool = false):
	if(get_value_from_connection && isConnected):
		match connectedTo.data_type:
			DATA_TYPE.NUMBER:
				_number_value = connectedTo._number_value;
			DATA_TYPE.STRING:
				_string_value = connectedTo._string_value;
			DATA_TYPE.CONTROL:
				_control_value = connectedTo._string_value;
	
	match data_type:
		DATA_TYPE.NUMBER:
			return _number_value;
		DATA_TYPE.STRING:
			return _string_value;
		DATA_TYPE.CONTROL:
			return _control_value;

func set_value(v):
	match data_type:
		DATA_TYPE.NUMBER:
			_number_value = v;
		DATA_TYPE.STRING:
			_string_value = v;
		DATA_TYPE.CONTROL:
			_control_value = v;
