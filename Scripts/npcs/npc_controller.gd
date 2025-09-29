class_name NPCController
extends CharacterBody3D

@export var npc_id: int = 0
@export var movement_speed: float = 5.0

var nav_agent: NavigationAgent3D


func _ready():
	nav_agent = NavigationAgent3D.new()
	add_child(nav_agent)
	nav_agent.debug_enabled = true
	add_to_group("npc")


func _physics_process(_delta):
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * movement_speed
	move_and_slide()


func set_target_position(pos: Vector3):
	nav_agent.target_position = pos


#region Encoding/Decoding
func get_save_data() -> Dictionary:
	return {
		"npc_id": npc_id,
		"movement_speed": movement_speed,
		"target_position": nav_agent.target_position,
		"position": global_position,
		"rotation_y": global_rotation.y,
	}


func load_from_data(data: Dictionary):
	npc_id = data.get("npc_id", 0)
	movement_speed = data.get("movement_speed", 5.0)
	set_target_position(data.get("target_position", Vector3.ZERO))
	global_position = data.get("position", Vector3.ZERO)
	global_rotation.y = data.get("rotation_y", 0.0)
#endregion
