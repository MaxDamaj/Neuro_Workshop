extends CanvasLayer
class_name UIExitLevelPanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var CloseButton : Button
@export var ExitButton : Button
@export var ReturnButton : Button


func _ready() -> void:
	ExitButton.button_down.connect(_exit_level)
	ReturnButton.button_down.connect(_return_back)
	CloseButton.button_down.connect(func(): _uiPanelsProvider.close_panel("exit_level_ui"))

func _return_back():
	_uiPanelsProvider.open_panel("settings_ui")
	_uiPanelsProvider.close_panel("exit_level_ui")

func _exit_level():
	get_tree().paused = false
	_levelLoadStartegy.unload_level()
