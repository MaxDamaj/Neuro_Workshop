extends Node
class_name UISafePanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var TakeButton : Button
@export var ReturnButton : Button


func _ready() -> void:
	TakeButton.button_down.connect(_take_item)
	ReturnButton.button_down.connect(func(): _uiPanelsProvider.close_panel("safe_ui"))


func _take_item():
	var player : PlayerView = get_tree().get_nodes_in_group("Player")[0]
	player.add_item("lava_lamp")
	_uiPanelsProvider.close_panel("exit_level_ui")
