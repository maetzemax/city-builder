extends PanelContainer

class_name UICardButton

@export var dispaly_name: String
@export var texture: Texture2D

@onready var texture_button: TextureButton = $VBoxContainer/TextureButton
@onready var label: Label = $VBoxContainer/Label

func _ready():
	texture_button.texture_normal = texture
	label.text = dispaly_name
