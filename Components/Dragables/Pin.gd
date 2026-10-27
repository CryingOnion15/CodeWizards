class_name Pin extends Dragable

enum PIN_TYPE {
	RECIEVER = 0, # Can only have another pin be dropped on this pin to make a connection.
	CONNECTOR = 1, # Can only drag from this pin to another to make a connection
	#BOTH = 2, # Can do both above.
}

enum DATA_TYPE {
	NUMBER,
	STRING,
	CONTROL,
	REFERENCE
}

#signals
signal pin_enter(pin: Pin); # Not used.
signal pin_exit(pin: Pin); # Not used.
signal pin_hover();
signal pin_hover_correct();
signal pin_hover_incorrect();
signal pin_connected();
signal pin_disconnected(pin: Pin);
signal pin_reset();

#static variables
static var NUMBER_COLOR: Color = Color('#008794');
static var STRING_COLOR: Color = Color('#FFDA03');
static var CONTROL_COLOR: Color = Color('#FEF9F3');
static var REFERENCE_COLOR: Color = Color('#BF00FF');
static var CorrectColor: Color = Color(0,128,0)
static var IncorrectColor: Color = Color(128,0,0)
static var ACTIVE_PIN: Pin = null;
static var SECONDARY_PIN = null;

# Properties
@export var pin_type: PIN_TYPE = PIN_TYPE.CONNECTOR;
@export var data_type: DATA_TYPE = DATA_TYPE.NUMBER;
@export var nested: bool = false;
@export var locked: bool = false;
@export var connection_node: Node = null;
@export var connection_parent: Node = null;
@export var pin_animation: AnimatedSprite2D = null;
@export var lock_sprite: Sprite2D = null;
@export var hardcoded_sprite: Sprite2D = null;
@export var default_label: Label = null;

# Variables
var connectedTo: Pin = null;
var connections: Array[PinConnection] = [];
var active_connection: PinConnection = null;
var isDrawingCurve: bool = false;
var is_setup: bool = false;
var is_hardcoded: bool = false;
var meta_data: Dictionary = {};
var default_value: Variant; #Needs to be set via data.
var value_signature: String = "";
var _value_callable: Callable = Callable();
var alter_control: bool = false;

#var _number_value = 0;
#var _control_value: CodePanel = null;
#var _reference_value: Array = []; #Element 0 = Wand, #Element 1 = var name.
var _id: String = "";
	
var id: String = "":
	get:
		if _id == "":
			_id = SaveDataUtility.get_UUID();
		return _id;
	set(value):
		_id = value;
		#TODO on delete need to remove all connections and reference from the Utility.
		PinConnectionManager.add_pin(_id, self); 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connection_node.mouse_entered.connect(_on_mouse_entered);
	connection_node.mouse_exited.connect(_on_mouse_exited);
	
	setup();
	#init_pin();
		
	if locked:
		locked_display();
	else:
		unlocked_display();
		
	if default_value && !connectedTo:
		show_default_value();
	else:
		default_label.hide();
		
	set_hardcode_display();

func setup():
	is_setup = true;
	add_to_group("Pin");
		
	reset();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for connection in connections:
		connection.draw();
		
		
func _on_mouse_entered() -> void:
	if locked || is_hardcoded:
		return;
	
	super._on_mouse_entered();
	
	## TODO handle alt control somewhere in here.
	if(Pin.ACTIVE_PIN != null):
		Pin.SECONDARY_PIN = self;
		
		if(check_valid_connection(Pin.ACTIVE_PIN)):
			correct_connect_hover();
		else:
			incorrect_connect_hover();
	# TODO need to refine the look and interaction of these.
	elif pin_type == PIN_TYPE.CONNECTOR:
		if can_multi_connect():
			hover();
		elif connections.size() == 0:
			hover();
	#elif connectedTo:
		#hover();

func _on_mouse_exited() -> void:
	if locked || is_hardcoded:
		return;
		
	super._on_mouse_exited();
	
	if(Pin.SECONDARY_PIN == self):
		Pin.SECONDARY_PIN = null;
	
	if pin_type == PIN_TYPE.RECIEVER:
		if !connectedTo:
			reset();
		else:
			emit_connected();
	else:
		if connections.size() == 0:
			reset();
		else:
			emit_connected();
		
func update_curve_on_drag(newPos):
	if active_connection:
		active_connection.update_end(newPos);

func show_default_value():
	if(default_value):
		default_label.show();
		#TODO need to account for default references.
		default_label.text = "%s" % [default_value];
		
		#TODO might need a more robust solution or reference. Might not matter.
		match pin_type:
			PIN_TYPE.RECIEVER:
				get_child(0).move_child(default_label, 1);
				return;
			PIN_TYPE.CONNECTOR:
				get_child(0).move_child(default_label, 0);
				return;
			#PIN_TYPE.BOTH:
				#get_child(0).move_child(default_label, 1);
				#return;
				
		get_child(0).move_child(default_label, 1);

func handle_start(event):
	if locked || is_hardcoded:
		return;
		
	var connect_cond: bool = connections.size() == 0 if data_type == Pin.DATA_TYPE.CONTROL else true;
	
	if(connectedTo && pin_type == Pin.PIN_TYPE.RECIEVER):
		#TODO need to work on getting this to pass the control to the connector pin.
		var pass_pin = connectedTo;
		disconnect_pin();
		Pin.SECONDARY_PIN = self;
		pass_pin.handle_start(event);
		correct_connect_hover();
		return;
		#connectedTo.disconnect_pin();
		#TODO need to handle the reconnection to the mouse.
		#Also need to think about how this goes back and forth.
		#Not 100% sure yet.
		
	elif pin_type == Pin.PIN_TYPE.CONNECTOR && connect_cond:
		Pin.ACTIVE_PIN = self;
		isDrawingCurve = true;
		#TODO also need to handle control pins. Because they can only have one connection. Maybe that is a mutli threading concept.
		#Also need to handle already connection pins. Disconnect.
		
		
		
		#Set up curve
		#TODO get retrieve existing from connected pin.
		get_active_connection();
		
		active_connection.update_start(connection_node.get_global_rect().get_center());
		active_connection.update_end(get_global_mouse_position());
		active_connection.draw();
		
		super.handle_start(event);	

func can_multi_connect() -> bool:
	return pin_type == PIN_TYPE.CONNECTOR && data_type != DATA_TYPE.CONTROL;

func get_active_connection():
	if !can_multi_connect() && connectedTo && connections.size() > 0:
		active_connection = connections[0];
		connectedTo = null;
	else:
		active_connection = PinConnectionManager.request_new_connection();
		active_connection.reparent(connection_parent);
		connections.push_back(active_connection);
		active_connection.connection_clicked.connect(on_connection_clicked.bind(active_connection));
		
	active_connection.owner_pin = self;

func on_connection_clicked(connection: PinConnection):
	if alter_control:
		connection.connector_pin.disconnect_pin();
		remove_connection_to_pin(connection.connector_pin);

func handle_end(event):
	if locked || is_hardcoded:
		return;
		
	if(Pin.ACTIVE_PIN == self):
		if(Pin.SECONDARY_PIN != null && check_valid_connection(Pin.SECONDARY_PIN)):
			if Pin.SECONDARY_PIN.connectedTo:
				Pin.SECONDARY_PIN.disconnect_pin();
			
			PinConnectionManager.add_connection(Pin.ACTIVE_PIN.id, Pin.SECONDARY_PIN.id);
			connect_to_pin(Pin.SECONDARY_PIN);
		else:
			reset();
			if active_connection:
				PinConnectionManager.add_connection_to_pool(active_connection);
				connections.pop_back();
				active_connection.connection_clicked.disconnect(on_connection_clicked);
				active_connection = null;
				
		Pin.ACTIVE_PIN = null;
		
	super.handle_end(event);
	
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
	pin_reset.emit();
	
func disconnect_pin():
	if connectedTo:
		show_default_value();		
		pin_disconnected.emit(self);
	elif connections.size() > 0:
		var pins: Array[Pin] = [];
		for connect in connections:
			pins.push_back(connect.connector_pin);
		
		#Done this way because the connection modifys the array which messes with the above loop.
		for pin in pins:
			pin.disconnect_pin();
		
		
	reset();	
	connectedTo = null;
	connections = [];

func remove_connection_to_pin(pin: Pin):
	var index = connections.find_custom(
			func(c: PinConnection): return c.connector_pin == pin
		)
		
	if index != -1:
		var r_connect = connections.pop_at(index);
		r_connect.connection_clicked.disconnect(on_connection_clicked);
		
		if connections.size() == 0:
			reset();
		
		PinConnectionManager.add_connection_to_pool(r_connect);
		pin.pin_disconnected.disconnect(remove_connection_to_pin);

#TODO I want to refine how pins are connected. With the id system should be a bit easier.
# I could even manager multi connections better.
func connect_to_id(id: String):
	var other = PinConnectionManager.get_pin_from_id(id);
	
	if other:
		connect_from_event(other);

func connect_from_event(pin: Pin, rotOverride: Vector2 = Vector2.ZERO, bezzierStrength: float = 100.0):
	Pin.ACTIVE_PIN = self;
	
	get_active_connection();
	active_connection.update_start(connection_node.get_global_rect().get_center());
	active_connection.update_end(pin.connection_node.get_global_rect().get_center());
	
	connect_to_pin(pin, rotOverride, bezzierStrength);
	
func connect_to_pin(pin: Pin, rotOverride: Vector2 = Vector2.ZERO, bezzierStrength: float = 100.0):
	#Is already connected to another pin.
	if(connectedTo != null):
		connectedTo.disconnect_pin();
	
	default_label.hide();
	pin_connected.emit();
	
	if(self == Pin.ACTIVE_PIN):
		isDrawingCurve = true;
		active_connection.connector_pin = pin;
		active_connection.update_end(pin.connection_node.get_global_rect().get_center());
		
		pin.connectedTo = self;
		pin.pin_disconnected.connect(remove_connection_to_pin);
		pin.emit_connected();
		Pin.ACTIVE_PIN = null;
		Pin.SECONDARY_PIN = null;
			
func emit_connected():
	pin_connected.emit();
	
func check_valid_connection(otherPin: Pin) -> bool:
	match pin_type:
		PIN_TYPE.RECIEVER:
			var validPinType = otherPin.pin_type == PIN_TYPE.CONNECTOR
			return validPinType && data_type == otherPin.data_type;
		PIN_TYPE.CONNECTOR:
			var validPinType = otherPin.pin_type == PIN_TYPE.RECIEVER
			return validPinType && data_type == otherPin.data_type;
	return false;
	
func get_value(get_value_from_connection: bool = false)->Variant:
	#TODO I think default value rule would only matter for reciever pins.
	if(!connectedTo && default_value):
		return default_value;
	
	if(get_value_from_connection && connectedTo):
		_value_callable = connectedTo._value_callable;
	
	var value = _value_callable.call() if _value_callable else null;
	
	if value:
		return value;
	else:
		match data_type:
			Pin.DATA_TYPE.NUMBER:
				return 0;
			Pin.DATA_TYPE.STRING:
				return "";
		
		return null;

func set_value(signature: String):
	value_signature = signature;
	parse_and_set_value();
	
func get_line_direction() -> Vector2:
	match pin_type:
		PIN_TYPE.RECIEVER:
			return Vector2.LEFT;
		PIN_TYPE.CONNECTOR:
			return Vector2.RIGHT;
	return Vector2.LEFT;

func set_locked_state(locked_state: bool):
	locked = locked_state;
	
	if locked:
		locked_display()
	else:
		unlocked_display();

func locked_display():
	lock_sprite.visible = true;
	pin_animation.modulate.a = .5;
	
func unlocked_display():
	lock_sprite.visible = false;
	pin_animation.modulate.a = 1;
	
func set_hardcode_display():
	hardcoded_sprite.visible = is_hardcoded;

func get_save_data() -> Dictionary:	
	return {
		"id": id,
		"connections": connection_save_data(),
		"connectedTo": connectedTo.id if connectedTo else "",
		"value": value_signature,
		"isHardcoded": is_hardcoded,
		"defaultValue": default_value,
		"isLocked": locked,
		"isNested": nested,
	}
	
func connection_save_data():
	var connection_sd = [];
	
	for connection in connections:
		connection_sd.push_back(connection.get_save_data());
	
	return connection_sd;
	
func set_meta_data(data: Dictionary):
	meta_data = data;
	
func parse_and_set_value():
	if value_signature != "":
		var parts = value_signature.split(":");
		var id = parts[0];
		var method = parts[1];
		var args = parts.slice(2);
		_value_callable = PinConnectionManager.get_connection_value_callback(parts[0], parts[1], args);
		
func init_pin():
	if not meta_data.is_empty():
		var save_id = meta_data.get("id");
		id = save_id if save_id else SaveDataUtility.get_UUID();

		var connections = meta_data.get("connections", []);
		for connection in connections:
			var owner = connection.get("owner", "");
			var connector = connection.get("connector", "");
			
			if(owner == _id && connector != ""):
				PinConnectionManager.add_connection(owner, connector);

		var value_sig = meta_data.get("value", "");
		if value_sig != "":
			value_signature = value_sig;
			
		var default = meta_data.get("defaultValue", null);
		default_value = default;
		
		is_hardcoded = meta_data.get("isHardcoded", false);
		set_hardcode_display();
		
func _input(event: InputEvent) -> void:
	
	if event.is_action("Alternate-Controls"):
		alter_control = event.is_pressed();
		
	super._input(event);

func handle_mouse_buttons(event):
	if isEntered && event.is_action_pressed("Click"):
		if alter_control:
			disconnect_pin();
		else:
			handle_start(event);
					
	if(isDragging && event.is_action_released("Click")):
		handle_end(event);
