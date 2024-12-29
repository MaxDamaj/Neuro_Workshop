extends Node
class_name UILosePanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var ExitButton : Button
@export var RestartButton : Button


func _ready() -> void:
	ExitButton.button_down.connect(_exit_level)
	RestartButton.button_down.connect(_restart_level)


func _exit_level():
	_levelLoadStartegy.unload_level()

func _restart_level():
	_levelLoadStartegy.restart_level()
