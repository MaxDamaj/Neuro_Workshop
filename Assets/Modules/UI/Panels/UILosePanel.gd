extends Node
class_name UILosePanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var ExitButton : Button
@export var RestartButton : Button


func _ready() -> void:
	ExitButton.button_down.connect(_exit_level)
	RestartButton.button_down.connect(_restart_level)
	UIPanelsProvider.close_panel("settings_ui")
	UIPanelsProvider.close_panel("recipe_book_ui")
	get_tree().paused = true


func _exit_level():
	get_tree().paused = false
	_levelLoadStartegy.unload_level()

func _restart_level():
	get_tree().paused = false
	_levelLoadStartegy.restart_level()
