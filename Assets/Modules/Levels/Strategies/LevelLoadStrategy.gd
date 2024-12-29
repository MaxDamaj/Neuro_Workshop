extends BaseProvider
class_name LevelLoadStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelLoadStrategy"

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var levels : Array[PackedScene]

var _allLevelTasks : Dictionary
var _loadedLevel : Node2D
var _loadedLevelId : int = -1

func _ready() -> void:
	_add_to_dictionary("res://Assets/Modules/Levels/Assets/Tasks", _allLevelTasks)
	_levelTasksStrategy.on_all_tasks_completed.connect(_win_game)
	_levelTasksStrategy.on_all_lifes_losed.connect(_lose_game)

func load_level(levelId : int) -> void:
	_loadedLevelId = levelId
	_uiPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : _load_level_callback})

func unload_level():
	_uiPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : _unload_level_callback})
	_loadedLevelId = -1

func restart_level():
	var end_func : Callable = func():
		_loadedLevel.queue_free()
		_levelTasksStrategy.stop_tasks()
		_uiPanelsProvider.close_panel("workshop_ui")
		_uiPanelsProvider.close_panel("lose_ui")
		_load_level_callback()
	
	_uiPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : end_func})

func _unload_level_callback():
	_loadedLevel.queue_free()
	_levelTasksStrategy.stop_tasks()
	_uiPanelsProvider.open_panel("main_ui")
	_uiPanelsProvider.close_panel("workshop_ui")
	_uiPanelsProvider.close_panel("exit_level_ui")
	_uiPanelsProvider.close_panel("lose_ui")

func _load_level_callback():
	_loadedLevel = levels[_loadedLevelId].instantiate()
	get_node("/root/MainScene").add_child.call_deferred(_loadedLevel)
	
	_levelTasksStrategy.allTasks = _allLevelTasks["level_" + str(_loadedLevelId)].Tasks
	_levelTasksStrategy.start_tasks()
	_uiPanelsProvider.open_panel("workshop_ui")
	_uiPanelsProvider.close_panel("main_ui")

func _win_game():
	if (_loadedLevelId + 1 >= levels.size()):
		unload_level()
		return
	
	_loadedLevelId += 1
	restart_level()

func _lose_game():
	_uiPanelsProvider.open_panel("lose_ui")
