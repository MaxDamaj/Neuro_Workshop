extends CanvasLayer
class_name UIWorkshopPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var SettingsButton : Button
@export var CloseSettingsButton : Button
@export var MainMenuButton : Button
@export var SettingsContainer : Control
@export var Lifes : Array[TextureRect]

func _ready() -> void:
	SettingsContainer.visible = false
	SettingsButton.button_down.connect(_switch_settings_panel)
	CloseSettingsButton.button_down.connect(_switch_settings_panel)
	MainMenuButton.button_down.connect(_try_close_level)

func _switch_settings_panel():
	SettingsContainer.visible = !SettingsContainer.visible

func _try_close_level():
	_uiPanelsProvider.open_panel("exit_level_ui")
