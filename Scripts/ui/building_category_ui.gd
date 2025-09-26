extends Control

@export var category: BuildingCategoryData

@onready var v_box_container: VBoxContainer = $VBoxContainer

const UI_CARD_BUTTON = preload("uid://b02r3c7dvucpi")

func _ready():
	v_box_container.add_to_group("ui_category_buildings")
	
	var root_category_button = UI_CARD_BUTTON.instantiate()
	root_category_button.category = category
	root_category_button.pressed.connect(_on_root_pressed)
	add_child(root_category_button)
	
	for building in category.buildings:
		var ui_card_button = UI_CARD_BUTTON.instantiate()
		ui_card_button.building = building
		ui_card_button.add_to_group("ui_card_buttons")
		v_box_container.add_child(ui_card_button)

func _on_root_pressed():
	var containers = get_tree().get_nodes_in_group("ui_category_buildings")
	
	for container in containers:
		container.visible = false
		
	v_box_container.visible = true
	
