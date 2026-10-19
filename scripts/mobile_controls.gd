extends CanvasLayer

@onready var joystick_base: Control = $Controls/JoystickBase
@onready var joystick_knob: Control = $Controls/JoystickBase/JoystickKnob

@export var joystick_radius: float = 65.0
@export var deadzone: float = 0.15

var joystick_direction: Vector2 = Vector2.ZERO
var active_touch_index: int = -1

func _ready() -> void:
	reset_joystick()
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if active_touch_index == -1:
				if is_inside_joystick(event.position):
					active_touch_index = event.index
					update_joystick(event.position)
		elif event.index == active_touch_index:
			active_touch_index = -1
			reset_joystick()
	elif event is InputEventScreenDrag:
		if event.index == active_touch_index:
			update_joystick(event.position)

# Obtiene el centro global del joystick base
func get_base_center() -> Vector2:
	return joystick_base.global_position + joystick_base.size / 2.0

func is_inside_joystick(screen_position: Vector2) -> bool:
	var center = get_base_center()
	return screen_position.distance_to(center) <= joystick_radius

func update_joystick(screen_position: Vector2) -> void:
	var center = get_base_center()
	var offset = screen_position - center
	var distance = offset.length()
	
	# Limitar el movimiento del knob al radio máximo del joystick
	if distance > joystick_radius:
		offset = offset.normalized() * joystick_radius
		distance = joystick_radius
	
	# Posicionar el knob en coordenadas locales respecto a la base
	var local_center = joystick_base.size / 2.0
	joystick_knob.position = local_center + offset - (joystick_knob.size / 2.0)
	
	# Calcular la dirección con la zona muerta (deadzone)
	var normalized_dist = distance / joystick_radius
	if normalized_dist < deadzone:
		joystick_direction = Vector2.ZERO
	else:
		# Normaliza y escala suavemente el vector resultante
		joystick_direction = offset.normalized() * ((normalized_dist - deadzone) / (1.0 - deadzone))

func reset_joystick() -> void:
	joystick_direction = Vector2.ZERO
	joystick_knob.position = (joystick_base.size - joystick_knob.size) / 2.0
