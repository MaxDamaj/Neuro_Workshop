extends Control
class_name TileBubble

@export var OrderIcon : TextureRect
@export var ProgressSlider : TextureProgressBar
@export var CrownIcon : Control
@export var ColorGrad : GradientTexture1D


func _ready() -> void:
	ProgressSlider.value_changed.connect(_change_color)

func _change_color(value : float):
	ProgressSlider.modulate = ColorGrad.gradient.sample(value / ProgressSlider.max_value)
