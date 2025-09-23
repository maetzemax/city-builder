extends Area3D

class_name Harvest

@export var data: HarvestData

@export var working_radius: Area3D

@export var is_active: bool = false

func _ready():
	working_radius.radius = data.working_radius
	TickManager.new_tick.connect(_on_new_tick)
	
func _process(_delta: float):
	for child in working_radius.get_children():
		if child is MeshInstance3D:
			child.visible = !is_active
	
func _on_new_tick():
	if not is_active:
		return
	
	var count = 0
	
	if working_radius.has_overlapping_areas():
		for commodity in working_radius.get_overlapping_areas():
			if count >= 3:
				break
				
			commodity.harvest(data.harvest_amount)
			count += 1
