class_name CitizenController
extends CharacterBody3D

@export var nav_agent: NavigationAgent3D
@export var camera: CameraController


func _ready():
	camera.clicked_element.connect(_on_clicked_element)


func _physics_process(_delta):
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * 5.0
	move_and_slide()


func _on_clicked_element(pos: Vector3):
	if GameManager.current_game_state != GameManager.GameState.BUILDING:
		nav_agent.target_position = pos
