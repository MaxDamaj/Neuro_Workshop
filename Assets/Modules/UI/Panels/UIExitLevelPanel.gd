extends CanvasLayer
class_name UIExitLevelPanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var CloseButton : Button
@export var ExitButton : Button
@export var ReturnButton : Button


func _ready() -> void:
	ExitButton.button_down.connect(_exit_level)
	ReturnButton.button_down.connect(_return_back)
	CloseButton.button_down.connect(func(): UIPanelsProvider.close_panel("exit_level_ui"))

func _return_back():
	get_tree().paused = false
	UIPanelsProvider.open_panel("settings_ui")
	UIPanelsProvider.close_panel("exit_level_ui")

func _exit_level():
	get_tree().paused = false
	_levelLoadStartegy.unload_level()
