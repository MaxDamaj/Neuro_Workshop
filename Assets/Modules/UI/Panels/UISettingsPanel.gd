extends Node
class_name UISettingsPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var CloseSettingsButton : Button
@export var MainMenuButton : Button


func _ready() -> void:
	get_tree().paused = true
	CloseSettingsButton.button_down.connect(_close_panel)
	MainMenuButton.button_down.connect(_try_close_level)

func _try_close_level():
	_uiPanelsProvider.open_panel("exit_level_ui")
	_uiPanelsProvider.close_panel("settings_ui")

func _close_panel():
	get_tree().paused = false
	_uiPanelsProvider.close_panel("settings_ui")
