extends Node

@export var navigation_manager: NavigationManager


func _ready():
	navigation_manager.bake_navigation()
