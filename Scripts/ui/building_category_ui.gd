extends Control

@export var category: BuildingCategoryData

@onready var root_box: VBoxContainer = $RootBox
@onready var v_box_container: VBoxContainer = $RootBox/VBoxContainer

const UI_CARD_BUTTON = preload("uid://b02r3c7dvucpi")

func _ready():
	var root_category_button = UI_CARD_BUTTON.instantiate()
	root_category_button.dispaly_name = category.display_name
	root_category_button.texture = category.icon
	root_box.add_child(root_category_button)
	
	for building in category.buildings:
		var ui_card_button = UI_CARD_BUTTON.instantiate()
		ui_card_button.dispaly_name = building.display_name
		ui_card_button.texture = building.icon
		v_box_container.add_child(ui_card_button)
