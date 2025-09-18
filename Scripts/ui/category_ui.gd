extends MenuButton

class_name CategoryUI

@export var build_manager: BuildManager
@export var placeables: Array[Placeable]

func _ready() -> void:
	var popup = get_popup()
	for placeable in placeables:
		popup.add_icon_item(placeable.icon, placeable.placeable_name)

	popup.index_pressed.connect(_on_index_pressed)

func _on_index_pressed(index):
	var selected_placeable = placeables[index]
	build_manager.update_selected_placeable(selected_placeable)
