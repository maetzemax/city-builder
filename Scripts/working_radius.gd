extends Area3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var radius: float

func _ready(): 
	var new_shape = SphereShape3D.new()
	var new_mesh = SphereMesh.new()
	
	new_shape.radius = radius
	
	new_mesh.radius = radius
	new_mesh.height = radius * 2
	
	collision_shape.shape = new_shape
	mesh_instance.mesh = new_mesh

func _process(_delta):
	if collision_shape.shape as SphereShape3D:
		collision_shape.shape.radius = radius
	
	if mesh_instance.mesh as SphereMesh:
		mesh_instance.mesh.radius = radius
		mesh_instance.mesh.height = radius * 2
