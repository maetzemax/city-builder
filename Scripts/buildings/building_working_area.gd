extends Area3D

class_name BuildingWorkingArea

@export var radius: float

func _ready():
	collision_layer = 0
	collision_mask = 4
	
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = radius
	
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = sphere_shape
	
	add_child(collision_shape)
