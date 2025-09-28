extends WorldEnvironment


@export var day_cover: Texture2D
@export var night_cover: Texture2D


func _ready():
	if GameManager.is_day:
		environment.sky.sky_material.sky_cover = day_cover
	else:
		environment.sky.sky_material.sky_cover = night_cover


func _on_cycle_controller_day_started() -> void:
	environment.sky.sky_material.sky_cover = day_cover


func _on_cycle_controller_night_started() -> void:
	environment.sky.sky_material.sky_cover = night_cover
