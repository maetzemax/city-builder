extends WorldEnvironment


@export var day_cover: Texture2D
@export var night_cover: Texture2D


func _ready():
	if GameManager.is_day:
		environment.sky.sky_material.sky_cover = day_cover
		environment.ambient_light_color = Color.WHITE.darkened(0.2)
	else:
		environment.sky.sky_material.sky_cover = night_cover
		environment.ambient_light_color = Color.WHITE.darkened(0.6)


func _on_cycle_controller_day_started() -> void:
	environment.sky.sky_material.sky_cover = day_cover
	environment.ambient_light_color = Color.WHITE.darkened(0.2)


func _on_cycle_controller_night_started() -> void:
	environment.sky.sky_material.sky_cover = night_cover
	environment.ambient_light_color = Color.WHITE.darkened(0.6)
