@tool

extends Area3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var radius: float

func _ready():
	if collision_shape.shape as SphereShape3D:
		collision_shape.shape.radius = radius
	
	if mesh_instance.mesh as SphereMesh:
		mesh_instance.mesh.radius = radius
		mesh_instance.mesh.height = radius * 2
		
	TickManager.new_tick.connect(_on_new_tick)

func _process(_delta):
	if Engine.is_editor_hint():
		if collision_shape.shape as SphereShape3D:
			collision_shape.shape.radius = radius
	
		if mesh_instance.mesh as SphereMesh:
			mesh_instance.mesh.radius = radius
			mesh_instance.mesh.height = radius * 2

func _on_new_tick():
	if has_overlapping_bodies():
		for commodity in get_overlapping_bodies():
			commodity.harvest(5)
