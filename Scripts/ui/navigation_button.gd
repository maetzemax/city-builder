extends Button

@export var scene: PackedScene
@export var should_load_save_file = false

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	GameData.should_load_save_file = should_load_save_file
	
	if not should_load_save_file:
		EconomyManager.reset_money()
	
	get_tree().change_scene_to_packed(scene)
