extends Light3D

func _process(_delta):
	self.visible = !GameManager.is_day
