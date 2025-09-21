extends Node3D

class_name DayAndNightCycle

#region Export

@export_group("General")

@export var sun_light: DirectionalLight3D
@export var world_environment: WorldEnvironment

@export_category("Day Settings")

@export var day_timer: Timer
@export var day_colors: GradientTexture2D
@export var day_length: float = 2.0
@export var day_light_energy: float = 1.0

@export_category("Night Settings")

@export var night_timer: Timer
@export var night_colors: GradientTexture2D
@export var night_length: float = 1.0
@export var night_light_energy: float = 0.2

#endregion

var _day_length_in_seconds: float
var _night_length_in_seconds: float

var day_progress: float
var night_progress: float

func _process(_delta):
	day_progress = 100 / _day_length_in_seconds * day_timer.time_left
	var day_progress_decimal = 1 - day_progress / 100

	night_progress = 100 / _night_length_in_seconds * night_timer.time_left
	var night_progress_decimal = 1 - night_progress / 100
	
	var is_day = !day_timer.is_stopped()
	GameManager.is_day = is_day
	sun_light.light_energy = day_light_energy if is_day else night_light_energy
	
	var sky_color = day_colors.gradient.sample(day_progress_decimal) if is_day else night_colors.gradient.sample(night_progress_decimal)
		
	if world_environment.environment:
		world_environment.environment.sky.sky_material.sky_top_color = sky_color
		world_environment.environment.sky.sky_material.sky_horizon_color = sky_color
		world_environment.environment.sky.sky_material.ground_bottom_color = sky_color
		world_environment.environment.sky.sky_material.ground_horizon_color = sky_color
	
	var day_angle = day_progress_decimal * 180.0     # 0° → 180°
	var night_angle = night_progress_decimal * 180.0 + 180.0  # 180° → 360°
	
	if is_day:
		sun_light.rotation_degrees.x = -day_angle
	else:
		sun_light.rotation_degrees.x = -night_angle

func _ready():
	_day_length_in_seconds = day_length * 60
	_night_length_in_seconds = night_length * 60
	
	day_timer.timeout.connect(_on_day_is_over)
	night_timer.timeout.connect(_on_night_is_over)
	
	day_timer.start(_day_length_in_seconds)

func _on_day_is_over():
	day_timer.stop()
	night_timer.start(_night_length_in_seconds)
	
func _on_night_is_over():
	night_timer.stop()
	day_timer.start(_day_length_in_seconds)
