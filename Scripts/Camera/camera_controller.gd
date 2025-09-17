extends Camera3D

signal clicked_element(pos: Vector3)

# Kamera-Einstellungen
@export var orbit_sensitivity: float = 0.005
@export var zoom_sensitivity: float = 0.05

# Bewegungsgeschwindigkeiten
@export var move_speed: float = 10.0
@export var fast_move_multiplier: float = 2.0
@export var slow_move_multiplier: float = 0.3
@export var scroll_zoom_speed: float = 1.0

# Input-Tracking
var is_orbiting: bool = false
var min_height = 10

func _ready():
	rotation_degrees = Vector3(-30, 0, 0)

func _input(event):
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		handle_mouse_motion(event)

func handle_mouse_button(event: InputEventMouseButton):
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			if event.pressed:
				shoot_ray()
		
		MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				start_orbiting()
			else:
				stop_camera_movement()
		
		MOUSE_BUTTON_WHEEL_UP:
			zoom_forward()
		
		MOUSE_BUTTON_WHEEL_DOWN:
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
	# Horizontale Rotation (Yaw - um globale Y-Achse)
	var yaw = -mouse_delta.x * orbit_sensitivity
	rotate_y(yaw)
	
	# Vertikale Rotation (Pitch - um lokale X-Achse)
	var pitch = -mouse_delta.y * orbit_sensitivity
	
	# Begrenze Pitch um Überschlagen zu verhindern
	var current_pitch = rotation.x
	var new_pitch = current_pitch + pitch
	new_pitch = clamp(new_pitch, deg_to_rad(-89), deg_to_rad(89))
	
	rotation.x = new_pitch

func zoom_forward():
	# Zoom in Blickrichtung (wie im Godot Editor)
	var forward = -transform.basis.z
	position += forward * scroll_zoom_speed
	position.y = clampf(position.y, min_height, position.y)

func zoom_backward():
	# Zoom zurück in Blickrichtung
	var forward = -transform.basis.z
	position -= forward * scroll_zoom_speed
	position.y = clampf(position.y, min_height, position.y)

func _process(delta):
	# WASD + QE Bewegung (wie im Godot Editor)
	handle_keyboard_movement(delta)

func handle_keyboard_movement(delta):
	var input_vector = Vector3()
	var speed = move_speed
	
	# Geschwindigkeits-Modifikatoren
	if Input.is_key_pressed(KEY_SHIFT):
		speed *= fast_move_multiplier
	elif Input.is_key_pressed(KEY_ALT):
		speed *= slow_move_multiplier
	
	# WASD Input (relativ zur Kamera-Orientierung)
	if Input.is_key_pressed(KEY_W):
		input_vector -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		input_vector += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		input_vector -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		input_vector += transform.basis.x
	
	# Auf/Ab mit Q/E (globale Y-Achse für City Builder)
	if Input.is_key_pressed(KEY_Q):
		input_vector.y -= 1.0
	if Input.is_key_pressed(KEY_E):
		input_vector.y += 1.0
	
	# Bewegung anwenden
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		var movement = input_vector * speed * delta
		position += movement
		position.y = clampf(position.y, min_height, position.y)

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	
	if raycast_result:
		var pos_x = raycast_result.position.x
		var pos_z = raycast_result.position.z
		
		var pos = Vector3(
			pos_x,
			raycast_result.position.y,
			pos_z
		)
		
		clicked_element.emit(pos)
