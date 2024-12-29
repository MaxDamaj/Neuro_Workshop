extends Node
class_name UISettingsPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var CloseSettingsButton : Button
@export var MainMenuButton : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CloseSettingsButton.button_down.connect(func(): _uiPanelsProvider.close_panel("settings_ui"))
	MainMenuButton.button_down.connect(_try_close_level)

func _try_close_level():
	_uiPanelsProvider.open_panel("exit_level_ui")
	_uiPanelsProvider.close_panel("settings_ui")
