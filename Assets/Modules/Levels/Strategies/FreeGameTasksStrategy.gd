extends LevelTasksStrategy
class_name FreeGameTasksStrategy

@export var baseTime : float = 150
@export var delayTime : float = 0.25
@export var saveScoreKey : String = "free_game_score"
@export var taskItems : Dictionary

var _totalScore : int
var _difficultyMultiplier : float = 1

func _ready() -> void:
	super._ready()
	_totalScore = 0
	tasksCount = 9999

func _exit_tree() -> void:
	stop_tasks()


func start_tasks():
	completedTasksCount = 0
	_remainingLoses = 3
	_taskPassedCount = 0
	_timer.start(delayTime)

func stop_tasks():
	_freeSpawners.clear()
	_timer.stop()
	
	var score = SaveDataProvider.get_saved_value(saveScoreKey, 0)
	if (_totalScore > score):
		SaveDataProvider.set_saved_value(saveScoreKey, _totalScore)

func complete_task(task : TaskModel, remainingTime : float):
	_difficultyMultiplier += 0.1
	var itemDifficulty : float = 1 if !taskItems.has(task.item) else taskItems[task.item]
	_totalScore += remainingTime * _difficultyMultiplier * itemDifficulty
	super.complete_task(task, remainingTime)

func get_tasks_text() -> String:
	return "Score: " + str(_totalScore)


func _end_task():
	if (_remainingLoses == 0): return
	if (_freeSpawners.size() == 0):
		_timer.start(2)
		return
	
	var task : TaskModel = _generate_random_task()
	var spawner : NpcSpawnerView = _freeSpawners.pick_random()
	_freeSpawners.erase(spawner)
	spawner.start_task(task)
	_timer.start(0.1)

func _generate_random_task() -> TaskModel:
	var task : TaskModel = TaskModel.new()
	task.delay = delayTime
	task.npcName = "random"
	task.item = taskItems.keys().pick_random()
	task.waitingTime = baseTime / _difficultyMultiplier
	return task
