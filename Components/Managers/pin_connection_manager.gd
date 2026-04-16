class_name PinConnectionManager extends Node

#var pins: Array[Pin]
var currentPin: Pin
var hoveredPin: Pin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pins = get_tree().get_nodes_in_group("Pin").map(func(node): return node as Pin)
	
	for pin in pins:
		pin.start_drag.connect(handle_start_drag)
		pin.end_drag.connect(handle_end_drag)
		pin.pin_enter.connect(handle_pin_enter)
		pin.pin_exit.connect(handle_pin_exit)

func handle_start_drag(startPos):
	if(hoveredPin):
		currentPin = hoveredPin;
		hoveredPin = null;
	
func handle_end_drag(endPos):
	if(currentPin):
		currentPin = null;
		
	if(hoveredPin):
		hoveredPin.hover();

func handle_pin_enter(pin: Pin):
	var possiblePins: Array[Pin] = pin.get_intersected_pins_at_mouse();
	if(possiblePins.size() > 0):
		var topPin: Pin = possiblePins[possiblePins.size() - 1];
		
		if(topPin == pin):
			print("New Hovered Pin")
			hoveredPin = pin;
		
		#Play hover effects
		if(currentPin == null):
			pin.hover();
		elif(currentPin != pin):
			if(currentPin.check_valid_connection(topPin)):
				topPin.correct_connect_hover();
			else:
				topPin.incorrect_connect_hover();

func handle_pin_exit(pin: Pin):
	if(hoveredPin && pin == hoveredPin):
		print("Hover Pin Null")
		hoveredPin.reset();
		hoveredPin = null;
