extends Control
class_name TileBubble

@export var OrderIcon : TextureRect
@export var ProgressSlider : TextureProgressBar
@export var CrownIcon : Control
@export var ItemNameLabel : Label
@export var ColorGrad : GradientTexture1D

@export var CheatButton : Button

var itemName : String

func _ready() -> void:
	ItemNameLabel.get_parent().visible = false
	ProgressSlider.value_changed.connect(_change_color)
	CheatButton.button_down.connect(_cheat_add_drink)

func set_item_name(itemName : String):
	ItemNameLabel.get_parent().visible = true
	ItemNameLabel.text = itemName

func _change_color(value : float):
	ProgressSlider.modulate = ColorGrad.gradient.sample(value / ProgressSlider.max_value)

func _cheat_add_drink():
	var player : PlayerView = get_tree().get_nodes_in_group("Player")[0]
	player.add_item(itemName)
