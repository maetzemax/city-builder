extends MenuButton

class_name CategoryUI

@export var build_manager: BuildManager
@export var buildings: Array[BuildingData]

func _ready() -> void:
	var popup = get_popup()
	for building in buildings:
		var cost_str = " %2.2f €" % building.construction_cost
		popup.add_item(building.display_name + cost_str)

	popup.index_pressed.connect(_on_index_pressed)

func _on_index_pressed(index):
	var selected_building = buildings[index]
	build_manager.update_selected_building(selected_building)
