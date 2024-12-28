extends BaseProvider
class_name LevelLoadStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelLoadStrategy"

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var levels : Array[PackedScene]

var _allLevelTasks : Dictionary
var _loadedLevel : Node2D

func _ready() -> void:
	_add_to_dictionary("res://Assets/Modules/Levels/Assets/Tasks", _allLevelTasks)

func load_level(levelId : int) -> void:
	var end_func : Callable = func():
		if (_loadedLevel != null): unload_level()
		
		_loadedLevel = levels[levelId - 1].instantiate()
		get_node("/root/MainScene").add_child.call_deferred(_loadedLevel)
		
		_uiPanelsProvider.open_panel("workshop_ui")
		_uiPanelsProvider.close_panel("main_ui")
	
	_uiPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : end_func})

func unload_level():
	var end_func : Callable = func():
		_loadedLevel.queue_free()
		_uiPanelsProvider.open_panel("main_ui")
		_uiPanelsProvider.close_panel("workshop_ui")
		_uiPanelsProvider.close_panel("exit_level_ui")
	
	_uiPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : end_func})
