extends Node

class_name SaveManager

@export var build_manager: BuildManager
@export var cycle_controller: CycleController

const SAVE_PATH = "user://game.save"

func _ready():
	if GameData.should_load_save_file:
		load_game()

func save_game():
	var save_data: Array[Dictionary] = []
	var buildings = get_tree().get_nodes_in_group("buildings")
	
	for building in buildings:
		if not building.is_preview:
			save_data.append(building.get_save_data())
	
	var npc_save_data: Array[Dictionary] = []
	var npcs = get_tree().get_nodes_in_group("npc")
	
	for npc in npcs:
		npc_save_data.append(npc.get_save_data())
	
	var camera_data: Dictionary = {
		"position": build_manager.camera.global_position,
		"rotation": build_manager.camera.global_rotation
	}
	
	var day_data: Dictionary = {
		"count": GameManager.day_count,
		"progress": GameManager.day_progress
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		var complete_save_data = {
			"buildings": save_data,
			"npcs": npc_save_data,
			"camera": camera_data,
			"day": day_data,
			"version": "0.1",
			"money": EconomyManager.money
		}
		file.store_var(complete_save_data)
		file.close()
		print("Game saved! ", save_data.size(), " buildings saved.")
	else:
		print("Failed to save game!")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found!")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		print("Failed to open save file!")
		return
	
	var save_data = file.get_var()
	file.close()
	
	clear_all_buildings()
	clear_all_citizens()
	
	if not save_data:
		return
	
	for building_data in save_data.buildings:
		var building = load(build_manager.buildings[building_data.building_id]).instantiate()
		add_child(building)
		building.load_from_data(building_data)
		
	for npc_data in save_data.npcs:
		var npc = load(NPCManager.npcs[npc_data.npc_id]).instantiate()
		add_child(npc)
		npc.load_from_data(npc_data)
	
	EconomyManager.money = save_data.money
	
	GameManager.day_count = save_data.day.count
	cycle_controller.set_cycle_progress(save_data.day.progress)
	
	build_manager.camera.global_position = save_data.camera.position
	build_manager.camera.global_rotation = save_data.camera.rotation
	
	print("Game loaded! ", save_data.buildings.size(), " buildings restored.")
	
func clear_all_buildings():
	var buildings = get_tree().get_nodes_in_group("buildings")
	
	for building in buildings:
		building.queue_free()
		
func clear_all_citizens():
	var npcs = get_tree().get_nodes_in_group("npc")
	
	for npc in npcs:
		npc.queue_free()
