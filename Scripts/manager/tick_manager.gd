extends Node

signal new_tick

var timer: Timer
var tick_time: float = 5.0

##How many seconds need to passed unti new tick
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(tick_time)
	
func _on_timer_timeout():
	new_tick.emit()
	timer.start(tick_time)
