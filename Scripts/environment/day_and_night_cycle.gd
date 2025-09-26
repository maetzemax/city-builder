extends Node3D
class_name DayAndNightCycle

#region Export
@export_category("Settings")
@export_group("General")
@export var is_menu: bool = false
@export var sun_light: DirectionalLight3D
@export var world_environment: WorldEnvironment

@export_group("Day")
@export var day_colors: GradientTexture2D
@export var day_length: float = 2.0
@export var day_light_energy: float = 1.0

@export_group("Night")
@export var night_colors: GradientTexture2D
@export var night_length: float = 1.0
@export var night_light_energy: float = 0.2

@export_group("Debug")
@export var show_debug_time: bool = false
#endregion

var day_length_in_seconds: float
var night_length_in_seconds: float
var current_time: float = 0.0
var cycle_time: float = 0.0
var is_day: bool = true

signal day_started
signal night_started

func _ready():
	day_length_in_seconds = day_length * 60
	night_length_in_seconds = night_length * 60
	cycle_time = day_length_in_seconds + night_length_in_seconds

func _process(delta):
	if GameManager.current_game_state == GameManager.GameState.PAUSED:
		return
	
	current_time += delta
	
	var previous_is_day = is_day
	
	if current_time < day_length_in_seconds:
		is_day = true
	else:
		is_day = false
	
	if previous_is_day != is_day:
		if is_day:
			day_started.emit()
		else:
			night_started.emit()
	
	if current_time >= cycle_time:
		current_time = 0.0
		is_day = true
		GameData.day_count += 1
		day_started.emit()
	
	if not is_menu:
		GameManager.is_day = is_day
	
	var progress: float
	if is_day:
		progress = current_time / day_length_in_seconds
	else:
		progress = (current_time - day_length_in_seconds) / night_length_in_seconds
	
	progress = clamp(progress, 0.0, 1.0)
	
	sun_light.light_energy = day_light_energy if is_day else night_light_energy
	
	var sky_color: Color
	if is_day:
		sky_color = day_colors.gradient.sample(progress)
	else:
		sky_color = night_colors.gradient.sample(progress)
	
	if world_environment.environment and world_environment.environment.sky:
		var sky_material = world_environment.environment.sky.sky_material
		if sky_material:
			sky_material.sky_top_color = sky_color
			sky_material.sky_horizon_color = sky_color
			sky_material.ground_bottom_color = sky_color
			sky_material.ground_horizon_color = sky_color
	
	var angle: float
	if is_day:
		angle = progress * 180.0  # 0° → 180°
	else:
		angle = progress * 180.0 + 180.0  # 180° → 360°
	
	sun_light.rotation_degrees.x = -angle
	
	if not is_menu:
		GameData.day_progress = (current_time / cycle_time) * 100
	
	# Debug Info
	if show_debug_time:
		_print_debug_info()

func get_current_time_formatted() -> String:
	var hours = int(current_time / 3600.0)
	var minutes = int(fmod(current_time, 3600.0) / 60.0)
	var seconds = int(fmod(current_time, 60.0))
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func get_day_progress() -> float:
	if is_day:
		return current_time / day_length_in_seconds
	else:
		return (current_time - day_length_in_seconds) / night_length_in_seconds

func set_time_of_day(progress: float):
	"""Setze die Tageszeit direkt (0.0 = Start des Tages, 1.0 = Ende des Zyklus)"""
	current_time = progress * cycle_time
	current_time = clamp(current_time, 0.0, cycle_time)

func skip_to_day():
	"""Springe direkt zum Tagesanfang"""
	current_time = 0.0
	is_day = true
	GameManager.is_day = true
	day_started.emit()

func skip_to_night():
	"""Springe direkt zum Nachtanfang"""
	current_time = day_length_in_seconds
	is_day = false
	GameManager.is_day = false
	night_started.emit()

func _print_debug_info():
	var cycle_progress = (current_time / cycle_time) * 100
	var phase = "Tag" if is_day else "Nacht"
	var phase_progress = get_day_progress() * 100
	
	print("Zeit: %s | Zyklus: %.1f%% | Phase: %s (%.1f%%)" % [
		get_current_time_formatted(),
		cycle_progress,
		phase,
		phase_progress
	])
