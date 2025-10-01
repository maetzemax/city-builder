extends Node3D

class_name CameraController

signal clicked_element(pos: Vector3)
signal mouse_pos_on_terrain(pos: Vector3)

@export var camera: Camera3D

@export var orbit_sensitivity: float = 0.005
@export var zoom_sensitivity: float = 0.05

@export var move_speed: float = 30.0
@export var fast_move_multiplier: float = 2.0
@export var slow_move_multiplier: float = 0.3
@export var scroll_zoom_speed: float = 1.0

var current_mouse_pos: Vector3

var is_orbiting: bool = false

func _physics_process(_delta: float):
	if GameManager.current_game_state == GameManager.GameState.PAUSED:
		return
	
	shoot_ray()

func _input(event):
	if GameManager.current_game_state == GameManager.GameState.PAUSED:
		return
	
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		handle_mouse_motion(event)

func handle_mouse_button(event: InputEventMouseButton):
	if GameManager.current_game_state == GameManager.GameState.PAUSED:
		return

	match event.button_index:
		MOUSE_BUTTON_LEFT:
			if event.pressed and current_mouse_pos:
				clicked_element.emit(current_mouse_pos)
		
		MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				start_orbiting()
			else:
				stop_camera_movement()
		
		MOUSE_BUTTON_WHEEL_UP:
			if not Input.is_key_pressed(KEY_CTRL):
				zoom_forward()
		
		MOUSE_BUTTON_WHEEL_DOWN:
			if not Input.is_key_pressed(KEY_CTRL):
				zoom_backward()
		
		MOUSE_BUTTON_RIGHT:
			if event.pressed:
				start_orbiting()
			else:
				stop_camera_movement()

func handle_mouse_motion(event: InputEventMouseMotion):
	if is_orbiting:
		orbit_camera(event.relative)

func start_orbiting():
	is_orbiting = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func stop_camera_movement():
	is_orbiting = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func orbit_camera(mouse_delta: Vector2):
	var yaw = -mouse_delta.x * orbit_sensitivity
	rotate_y(yaw)
	
	var pitch = -mouse_delta.y * orbit_sensitivity
	
	var current_pitch = rotation.x
	var new_pitch = current_pitch + pitch
	new_pitch = clamp(new_pitch, deg_to_rad(-89), deg_to_rad(89))
	
	rotation.x = new_pitch

func zoom_forward():
	var forward = -transform.basis.z
	position += forward * scroll_zoom_speed

func zoom_backward():
	var forward = -transform.basis.z
	position -= forward * scroll_zoom_speed

func _process(delta):
	if GameManager.current_game_state == GameManager.GameState.PAUSED:
		return

	handle_keyboard_movement(delta)

func handle_keyboard_movement(delta):
	var input_vector = Vector3()
	var speed = move_speed
	
	if Input.is_key_pressed(KEY_SHIFT):
		speed *= fast_move_multiplier
	elif Input.is_key_pressed(KEY_ALT):
		speed *= slow_move_multiplier
	
	if Input.is_key_pressed(KEY_W):
		input_vector -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		input_vector += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		input_vector -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		input_vector += transform.basis.x
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		var movement = input_vector * speed * delta
		position += movement

func shoot_ray():
	Builder.is_mouse_over_ui = is_mouse_over_ui()
	
	if is_mouse_over_ui():
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = 8
	
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:
		var pos = Vector3(
			raycast_result.position.x,
			raycast_result.position.y,
			raycast_result.position.z
		)
		
		mouse_pos_on_terrain.emit(pos)
		current_mouse_pos = pos

func is_mouse_over_ui() -> bool:
	var viewport = get_viewport()
	var hovered_control = viewport.gui_get_hovered_control()
	
	if not hovered_control:
		return false
	
	# Prüfe ob das Control effektiv interagierbar ist
	return is_control_interactive(hovered_control)

func is_control_interactive(control: Control) -> bool:
	var _current = control
	while _current:
		# Wenn ein Parent unsichtbar ist, ist das Control nicht interaktiv
		if not _current.visible:
			return false
		
		# Wenn mouse_filter auf IGNORE steht, blockiert es keine Maus-Events
		if _current.mouse_filter == Control.MOUSE_FILTER_IGNORE:
			_current = _current.get_parent() as Control
			continue
			
		_current = _current.get_parent() as Control
	
	return true
