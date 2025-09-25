extends MarginContainer

@export_group("Day")
@export var day_label: Label
@export var day_progress: ProgressBar

@export_group("Economic")
@export var money_label: Label

func _process(_delta):
	day_label.text = "Day %o" % GameData.day_count
	day_progress.value = GameData.day_progress
	money_label.text = "%2.2f €" % EconomyManager.money
