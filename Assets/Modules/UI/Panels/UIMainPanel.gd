extends CanvasLayer
class_name UIMainPanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var LevelButtons : Array[Button]


func _ready() -> void:
	for i in range(LevelButtons.size()):
		var index : int = i + 1
		LevelButtons[i].button_down.connect(func(): _load_level(index))


func _load_level(levelId : int):
	_levelLoadStartegy.load_level(levelId)
