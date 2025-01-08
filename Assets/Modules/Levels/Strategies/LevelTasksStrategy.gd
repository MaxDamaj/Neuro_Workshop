extends Node
class_name LevelTasksStrategy

static var path : NodePath

@onready var _dialogsProvider : DialogsProvider = get_node(DialogsProvider.path)
@onready var _levelLoadStrategy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

signal on_task_status_updated(text : String)
signal on_life_lost(totalLifes : int, remainingLifes : int)

var levelTaskModel : LevelTasksModel
var tasksCount : int
var completedTasksCount : int
var lastStartedTask : TaskModel

var _allSpawners : Array[NpcSpawnerView]
var _freeSpawners : Array[NpcSpawnerView]
var _timer : Timer
var _nextTaskIndex : int = 0
var _taskPassedCount : int
var _remainingLoses : int

func _ready() -> void:
	path = get_path()
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_end_task)
	
	var levelModel : LevelTasksModel = _levelLoadStrategy.allLevelTasks["level_" + str(_levelLoadStrategy.loadedLevelId)]
	levelTaskModel = levelModel
	tasksCount = levelModel.TasksCount
	start_tasks()


func register_spawner(spawner : NpcSpawnerView, isBusy : bool = false):
	_allSpawners.append(spawner)
	if (!isBusy): _freeSpawners.append(spawner)


func start_tasks():
	if (levelTaskModel == null || levelTaskModel.Tasks.size() == 0): return
	
	completedTasksCount = 0
	_remainingLoses = 3
	_taskPassedCount = 0
	_nextTaskIndex = 0
	_timer.start(levelTaskModel.Tasks[_nextTaskIndex].delay)

func stop_tasks():
	_freeSpawners.clear()
	_timer.stop()

func complete_task(task : TaskModel, _remainingTime : float):
	completedTasksCount += 1
	_taskPassedCount += 1
	on_task_status_updated.emit(get_tasks_text())
	
	_dialogsProvider.try_start_dialog(task.dialogId, _end_game_check)

func lose_task(task : TaskModel):
	_remainingLoses -= 1 if task.rarity == 0 else 3
	_taskPassedCount += 1
	on_life_lost.emit(3, _remainingLoses)
	
	if (_remainingLoses <= 0):
		_levelLoadStrategy.lose_game()
		stop_tasks()
		return
	
	if (_taskPassedCount >= tasksCount):
		_levelLoadStrategy.win_game()

func free_spawner(spawner : NpcSpawnerView):
	_freeSpawners.append(spawner)

func get_tasks_text() -> String:
	return "Drinks served: " + str(completedTasksCount) + "/" + str(tasksCount)

func _end_game_check():
	if (_taskPassedCount >= tasksCount):
		_dialogsProvider.try_start_dialog(levelTaskModel.EndDialog, func(): _levelLoadStrategy.win_game())

func _end_task():
	if (_remainingLoses == 0): return
	if (_freeSpawners.size() == 0):
		_timer.start(2)
		return
	
	var task : TaskModel = levelTaskModel.Tasks[_nextTaskIndex]
	if (task.completedTasksCount > completedTasksCount):
		_timer.start(2)
		return
	
	var spawner : NpcSpawnerView = _freeSpawners.pick_random() if levelTaskModel.Tasks.size() > 1 else _freeSpawners[1]
	_freeSpawners.erase(spawner)
	spawner.start_task(task)
	
	_nextTaskIndex += 1
	
	if (_nextTaskIndex >= levelTaskModel.Tasks.size()): return
	_timer.start(levelTaskModel.Tasks[_nextTaskIndex].delay)
