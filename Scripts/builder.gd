extends Node3D

@export var scene: PackedScene

func _on_camera_3d_clicked_element(pos: Vector3) -> void:
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = pos
	print(pos)
