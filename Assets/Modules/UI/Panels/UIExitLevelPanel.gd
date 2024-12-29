extends CanvasLayer
class_name UIExitLevelPanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var CloseButton : Button
@export var ExitButton : Button
@export var ReturnButton : Button


func _ready() -> void:
	ExitButton.button_down.connect(_exit_level)
	ReturnButton.button_down.connect(func(): _uiPanelsProvider.close_panel("exit_level_ui"))
	CloseButton.button_down.connect(func(): _uiPanelsProvider.close_panel("exit_level_ui"))


func _exit_level():
	_levelLoadStartegy.unload_level()
