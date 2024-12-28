extends PathFollow2D
class_name NpcSpawnerView

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)

var _timer : Timer
var _maxTime : float
var _npc : NpcView


func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_end_moving)
	
	_levelTasksStrategy.register_spawner(self)

func _process(delta: float) -> void:
	if (_timer.time_left > 0):
		progress_ratio = 1 - _timer.time_left / _maxTime


func add_npc(npc : NpcView):
	_npc = npc
	add_child(_npc)
	_npc.rotation_degrees = -90
	_npc.Animator.play("Walk")
	_maxTime = 5
	_timer.start(_maxTime)

func _end_moving():
	_npc.Animator.play("Idle")
