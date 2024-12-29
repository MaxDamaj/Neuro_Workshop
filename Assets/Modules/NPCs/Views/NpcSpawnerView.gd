extends PathFollow2D
class_name NpcSpawnerView

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)
@onready var _npcsProvider : NpcsProvider = get_node(NpcsProvider.path)

var _npc : NpcView
var _task : TaskModel

func _ready() -> void:
	_levelTasksStrategy.register_spawner(self)


func start_task(task : TaskModel):
	_task = task
	_npc = _npcsProvider.get_npc(task.npcName)
	add_child(_npc)
	_npc.rotation_degrees = -90
	_npc.Animator.play("Walk")
	_move_npc(0, 1, 5, _end_moving)

func _end_moving():
	_npc.Animator.play("Idle")
	_npc.start_task(_task)


func _move_npc(startRatio : float, targetRatio : float, time : float, callback : Callable):
	var tween = create_tween()
	progress_ratio = startRatio
	tween.tween_property(self, "progress_ratio", targetRatio, time)
	tween.tween_callback(callback)
