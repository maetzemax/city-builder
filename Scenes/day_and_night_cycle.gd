extends Node3D

class_name DayAndNightCycle

@export var sky_colors: GradientTexture2D

@export var sun_light: DirectionalLight3D
@export var world_environment: WorldEnvironment

@export var timer: Timer

@export var day_length: float = 5.0
var _day_length_in_seconds: float

var progress: float

func _process(_delta):
	progress = 100 / _day_length_in_seconds * timer.time_left
	var progress_decimal = 1 - progress / 100

	var sky_color = sky_colors.gradient.sample(progress_decimal)
	if world_environment.environment:
		world_environment.environment.sky.sky_material.sky_top_color = sky_color
		world_environment.environment.sky.sky_material.sky_horizon_color = sky_color
		world_environment.environment.sky.sky_material.ground_bottom_color = sky_color
		world_environment.environment.sky.sky_material.ground_horizon_color = sky_color
		
	var sun_angle = progress * 3.6
	sun_light.rotation_degrees.x = -sun_angle
	
	if sun_angle > 180.0:
		sun_light.visible = false
	else:
		sun_light.visible = true


func _ready():
	_day_length_in_seconds = day_length * 60
	
	timer.timeout.connect(_on_day_is_over)
	timer.start(_day_length_in_seconds)
	
	progress = _day_length_in_seconds / timer.time_left

func _on_day_is_over():
	timer.start(_day_length_in_seconds)
