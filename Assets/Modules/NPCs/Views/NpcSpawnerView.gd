extends PathFollow2D
class_name NpcSpawnerView

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)
@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)
@onready var _npcsProvider : NpcsProvider = get_node(NpcsProvider.path)

@export var BarTable : DecorBarTableView

var _npc : NpcView
var _task : TaskModel

func _ready() -> void:
	_levelTasksStrategy.register_spawner(self)
	BarTable.on_item_recieved.connect(_item_recieved)


func start_task(task : TaskModel):
	_task = task
	_npc = _npcsProvider.get_npc(task.npcName)
	add_child(_npc)
	_npc.rotation_degrees = -90
	_move_npc(0, 1, 5, _end_moving)
	_npc.on_task_lose.connect(_task_failed)
	
	BarTable.taskItem = task.item
	_soundProvider.play_sound("door_bell")

func _item_recieved():
	BarTable.remove_item()
	_levelTasksStrategy.complete_task(_task)
	
	if (_task.nextTask != null):
		_task = _task.nextTask
		BarTable.taskItem = _task.item
		_npc.start_task(_task)
	else:
		_npc.end_task()
		_move_npc(1, 0, 4, _complete_task)

func _task_failed():
	_npc.hide_bubble()
	BarTable.taskItem = ""
	_levelTasksStrategy.lose_task(_task)
	_move_npc(1, 0, 4, _complete_task)

func _end_moving():
	if (_npc == null): return
	_npc.Animator.play("Idle")
	_npc.start_task(_task)

func _complete_task():
	if (_npc == null): return
	_npc.on_task_lose.disconnect(_task_failed)
	_npc.queue_free()
	_levelTasksStrategy.free_spawner(self)


func _move_npc(startRatio : float, targetRatio : float, time : float, callback : Callable):
	var tween = create_tween()
	if (startRatio == 1):
		if (_npc.Root != null):
			_npc.Root.scale = Vector2(-1, 1)
		else:
			_npc.scale = Vector2(-1, 1)
	
	progress_ratio = startRatio
	tween.tween_property(self, "progress_ratio", targetRatio, time)
	tween.tween_callback(callback)
	_npc.Animator.play("Walk")
