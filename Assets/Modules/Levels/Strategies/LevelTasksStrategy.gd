extends Node
class_name LevelTasksStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelTasksStrategy"

@onready var _npcsProvider : NpcsProvider = get_node(NpcsProvider.path)

var _allSpawners : Array[NpcSpawnerView]
var _timer : Timer
var _nextTask : String

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_end_task)
	
	_start_task("spawn_npc", 4)

func try_complete_task(itemName : String, tableId : int) -> bool:
	return true

func register_spawner(spawner : NpcSpawnerView):
	_allSpawners.append(spawner)


func _start_task(task : String, duration : float):
	_nextTask = task
	_timer.start(duration)

func _end_task():
	match _nextTask:
		"spawn_npc": 
			_allSpawners.pick_random().add_npc(_npcsProvider.get_random_npc())
