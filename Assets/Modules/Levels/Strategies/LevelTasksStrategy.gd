extends Node
class_name LevelTasksStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelTasksStrategy"

@onready var _dialogsProvider : DialogsProvider = get_node(DialogsProvider.path)
@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

signal on_task_completed(totalProgress : int, currentProgress : int)
signal on_life_lost(totalLifes : int, remainingLifes : int)
signal on_all_tasks_completed
signal on_all_lifes_losed

var allTasks : Array[TaskModel]
var tasksCount : int

var completedTasksCount : int

var _allSpawners : Array[NpcSpawnerView]
var _freeSpawners : Array[NpcSpawnerView]
var _timer : Timer
var _nextTaskIndex : int = 0
var _taskPassedCount : int
var _remainingLoses : int

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_end_task)


func register_spawner(spawner : NpcSpawnerView):
	_allSpawners.append(spawner)
	_freeSpawners.append(spawner)


func start_tasks():
	if (tasksCount == 0):
		await get_tree().create_timer(0.2).timeout
		_levelLoadStartegy._win_game()
		return
	
	if (allTasks == null): return
	
	completedTasksCount = 0
	_remainingLoses = 3
	_taskPassedCount = 0
	_nextTaskIndex = 0
	_timer.start(allTasks[_nextTaskIndex].delay)

func stop_tasks():
	_freeSpawners.clear()
	_timer.stop()

func complete_task(task : TaskModel):
	completedTasksCount += 1
	_taskPassedCount += 1
	on_task_completed.emit(tasksCount, completedTasksCount)
	
	if (task.dialogId != ""):
		_dialogsProvider.try_start_dialog(task.dialogId, func():
			if (_taskPassedCount >= tasksCount):
				on_all_tasks_completed.emit()
			)

func lose_task(task : TaskModel):
	_remainingLoses -= 1 if task.rarity == 0 else 3
	_taskPassedCount += 1
	on_life_lost.emit(3, _remainingLoses)
	
	if (_remainingLoses <= 0):
		on_all_lifes_losed.emit()
		stop_tasks()
		return
	
	if (_taskPassedCount >= tasksCount):
		on_all_tasks_completed.emit()

func free_spawner(spawner : NpcSpawnerView):
	_freeSpawners.append(spawner)

func _end_task():
	if (_remainingLoses == 0): return
	if (_freeSpawners.size() == 0):
		_timer.start(2)
		return
	
	var task : TaskModel = allTasks[_nextTaskIndex]
	if (task.completedTasksCount > completedTasksCount):
		_timer.start(2)
		return
	
	var spawner : NpcSpawnerView = _freeSpawners.pick_random() if allTasks.size() > 1 else _freeSpawners[1]
	_freeSpawners.erase(spawner)
	spawner.start_task(task)
	
	_nextTaskIndex += 1
	
	if (_nextTaskIndex >= allTasks.size()): return
	_timer.start(allTasks[_nextTaskIndex].delay)
