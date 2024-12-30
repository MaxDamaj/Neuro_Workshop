extends Node
class_name LevelTasksStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelTasksStrategy"

signal on_task_completed(totalProgress : int, currentProgress : int)
signal on_life_lost(totalLifes : int, remainingLifes : int)
signal on_all_tasks_completed
signal on_all_lifes_losed

var allTasks : Array[TaskModel]

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

func try_complete_task(itemName : String, tableId : int) -> bool:
	return true

func register_spawner(spawner : NpcSpawnerView):
	_allSpawners.append(spawner)
	_freeSpawners.append(spawner)


func start_tasks():
	if (allTasks == null || allTasks.size() == 0): return
	completedTasksCount = 0
	_remainingLoses = 3
	_taskPassedCount = 0
	_nextTaskIndex = 0
	_timer.start(allTasks[_nextTaskIndex].delay)

func stop_tasks():
	_freeSpawners.clear()
	_timer.stop()

func complete_task():
	completedTasksCount += 1
	_taskPassedCount += 1
	on_task_completed.emit(allTasks.size(), completedTasksCount)
	
	if (_taskPassedCount >= allTasks.size()):
		on_all_tasks_completed.emit()

func lose_task(task : TaskModel):
	_remainingLoses -= 1 if task.rarity == 0 else 3
	_taskPassedCount += 1
	on_life_lost.emit(3, _remainingLoses)
	
	if (_remainingLoses <= 0):
		on_all_lifes_losed.emit()
		stop_tasks()
		return
	
	if (_taskPassedCount >= allTasks.size()):
		on_all_tasks_completed.emit()

func free_spawner(spawner : NpcSpawnerView):
	_freeSpawners.append(spawner)

func _end_task():
	if (_remainingLoses == 0): return
	if (_freeSpawners.size() == 0):
		_timer.start(2)
		return
	
	var task : TaskModel = allTasks[_nextTaskIndex]
	var spawner : NpcSpawnerView = _freeSpawners.pick_random()
	_freeSpawners.erase(spawner)
	spawner.start_task(task)
	_nextTaskIndex += 1
	
	if (_nextTaskIndex >= allTasks.size()): return
	_timer.start(allTasks[_nextTaskIndex].delay)
