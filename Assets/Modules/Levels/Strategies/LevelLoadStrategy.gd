extends BaseProvider
class_name LevelLoadStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelLoadStrategy"

@onready var _dialogsProvider : DialogsProvider = get_node(DialogsProvider.path)
@onready var _tutorialFactory : TutorialFactory = get_node(TutorialFactory.path)
@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

@export var levels : Dictionary
@export var lastLevelId : int

var safeCode : int
var allLevelTasks : Dictionary
var loadedLevelId : int = -99
var lastUnlockedLevel : int:
	set(value):
		SaveDataProvider.set_saved_value("last_Unlocked_Level", value)
		lastUnlockedLevel = value
	get:
		return lastUnlockedLevel

var _loadedLevel : Node2D

func _ready() -> void:
	lastUnlockedLevel = SaveDataProvider.get_saved_value("last_Unlocked_Level", 0)
	_add_to_dictionary("res://Assets/Modules/Levels/Assets/Tasks", allLevelTasks)

func load_level(levelId : int) -> void:
	loadedLevelId = levelId
	safeCode = randi_range(0, 9999)
	if(levelId!=0 && levelId!=4 && levelId!=5):
		_soundProvider.play_music("default_theme")
	UIPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : _load_level_callback})

func unload_level():
	UIPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : _unload_level_callback})
	loadedLevelId = -99

func restart_level():
	var end_func : Callable = func():
		_loadedLevel.queue_free()
		_tutorialFactory.unload_tutorial()
		UIPanelsProvider.close_panel("workshop_ui")
		UIPanelsProvider.close_panel("lose_ui")
		_load_level_callback()
	
	safeCode = randi_range(0, 9999)
	UIPanelsProvider.open_panel_with_args("loading_ui", {"end_func" : end_func})

func win_game():
	EventsProvider.call_event("you win!")
	if (loadedLevelId + 1 >= lastLevelId || loadedLevelId + 1 <= 0):
		unload_level()
		return
	
	loadedLevelId += 1
	if (lastUnlockedLevel < loadedLevelId): lastUnlockedLevel = loadedLevelId
	restart_level()

func lose_game():
	EventsProvider.call_event("you lose")
	UIPanelsProvider.open_panel("lose_ui")

func _unload_level_callback():
	_loadedLevel.queue_free()
	_tutorialFactory.unload_tutorial()
	UIPanelsProvider.open_panel("main_ui")
	UIPanelsProvider.close_panel("workshop_ui")
	UIPanelsProvider.close_panel("dialog_ui")
	UIPanelsProvider.close_panel("exit_level_ui")
	UIPanelsProvider.close_panel("lose_ui")

func _load_level_callback():
	_loadedLevel = levels[loadedLevelId].instantiate()
	get_node("/root/MainScene").add_child.call_deferred(_loadedLevel)
	
	var levelModel : LevelTasksModel = allLevelTasks["level_" + str(loadedLevelId)]
	_dialogsProvider.try_start_dialog(levelModel.StartDialog, func(): pass)
	_tutorialFactory.spawn_tutorial(loadedLevelId)
	
	UIPanelsProvider.open_panel("workshop_ui")
	UIPanelsProvider.close_panel("main_ui")
