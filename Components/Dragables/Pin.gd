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

#static variables
static var LINE_POINT_COUNT = 12;
static var NUMBER_COLOR: Color = Color('#008794');
static var STRING_COLOR: Color = Color('#FFDA03');
static var CONTROL_COLOR: Color = Color('#FEF9F3');
static var CorrectColor: Color = Color(0,128,0)
static var IncorrectColor: Color = Color(128,0,0)
static var ACTIVE_PIN: Pin = null;
static var SECONDARY_PIN = null;

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
	if(isDrawingCurve && line):
		if(isConnected && connectedTo != null):
			var localEnd = line.to_local(connectedTo.get_global_rect().get_center())
			curve.set_point_position(1, localEnd);
		
		curve.set_point_position(0, line.to_local(get_global_rect().get_center()));
		line.points = curve.get_baked_points()
		
func _on_mouse_entered() -> void:
	super._on_mouse_entered();
	
	if(Pin.ACTIVE_PIN != null):
		Pin.SECONDARY_PIN = self;
		
		if(check_valid_connection(Pin.ACTIVE_PIN)):
			correct_connect_hover();
		else:
			incorrect_connect_hover();
	elif not isConnected:
		hover();

func _on_mouse_exited() -> void:
	super._on_mouse_exited();
	
	if(Pin.SECONDARY_PIN == self):
		Pin.SECONDARY_PIN = null;
	
	if not isConnected:
		reset();
	else:
		emit_connected();		
		
# Warning tool to ensure right components.
func _get_configuration_warnings():
	if not has_node("Line2D"):
		return ["This node requires a Line2D child to draw the line of the connection."]
	return []
		
func update_curve_on_drag(newPos):
	var localEnd = line.to_local(newPos)
	curve.set_point_position(1, localEnd);

#func handle_mouse_buttons(event: InputEvent):	
	### Handle Start Drag.
	#if(isEntered && event.is_action_pressed("Mouse1")):
		#handle_start(event)
#
	### Handle End Drag
	#if(isDragging && event.is_action_released("Mouse1")):
		#handle_end(event)

func handle_start(event):
	if(isConnected):
		if(connectedTo):
			connectedTo.disconnect_pin();
		disconnect_pin();
		hover();
	
	connectedTo = null;
	Pin.ACTIVE_PIN = self;
	isDrawingCurve = true;
	
	#Set up curve
	curve.clear_points();
	curve.add_point(line.to_local(get_global_rect().get_center()));
	curve.add_point(line.to_local(global_position));
	curve.set_point_out(0, get_line_direction() * 100);
	
	super.handle_start(event);	
	
func handle_end(event):		
	if(Pin.ACTIVE_PIN == self):
		if(Pin.SECONDARY_PIN != null && check_valid_connection(Pin.SECONDARY_PIN)):	
			connect_to_pin(Pin.SECONDARY_PIN);
			Pin.SECONDARY_PIN.connect_to_pin(self);
			Pin.SECONDARY_PIN = null;
		else:
			clear_line();
			reset();
		
		Pin.ACTIVE_PIN = null;
		
	super.handle_end(event)
	
#func get_intersected_pins_at_mouse() -> Array[Pin]:
	##Test the intersection points.
	#var pointParmeters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	#pointParmeters.position = get_global_mouse_position()
	#pointParmeters.collide_with_areas = true
	#
	#var objects_clicked = get_world_2d().direct_space_state.intersect_point(pointParmeters)
	#
	#if(objects_clicked.size() > 0):	
		#var pins: Array[Pin] = []
#
		#for obj in objects_clicked:
			#if obj.collider is Pin:
				#pins.append(obj.collider as Pin)
#
		#pins.sort_custom(
			#func(c1: Pin, c2: Pin):
				#return c1.z_index < c2.z_index
		#)
#
		#return pins
	#return []
func clear_line():
	isDrawingCurve = false;
	line.points = [];
	
func drag(delta):
	super.drag(delta);
	update_curve_on_drag(get_global_mouse_position());

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
	
	if(self == Pin.ACTIVE_PIN):
		var localEnd = line.to_local(pin.get_global_rect().get_center());
		curve.set_point_position(1, localEnd);

		var rotVector = pin.get_line_direction() * 100.0
		curve.set_point_in(1, rotVector)
	
func emit_connected():
	pin_connected.emit();
	
func check_valid_connection(otherPin: Pin) -> bool:
	match pin_type:
		PIN_TYPE.RECIEVER:
			var validPinType = otherPin.pin_type == PIN_TYPE.CONNECTOR || otherPin.pin_type == PIN_TYPE.BOTH
			return validPinType && data_type == otherPin.data_type;
		PIN_TYPE.CONNECTOR:
			var validPinType = otherPin.pin_type == PIN_TYPE.RECIEVER || otherPin.pin_type == PIN_TYPE.BOTH
			return validPinType && data_type == otherPin.data_type;
		PIN_TYPE.BOTH:
			return data_type == otherPin.data_type;
	return false;
	
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
			
func get_line_direction() -> Vector2:
	match pin_type:
		PIN_TYPE.RECIEVER:
			return Vector2.LEFT;
		PIN_TYPE.CONNECTOR:
			return Vector2.RIGHT;
		PIN_TYPE.BOTH:
			return Vector2.LEFT;
	return Vector2.LEFT;
