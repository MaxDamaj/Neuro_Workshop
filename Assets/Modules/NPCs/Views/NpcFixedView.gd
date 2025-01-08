extends NpcSpawnerView
class_name NpcFixedView

@export var npcName : String

signal on_order_finished(context : String)

func _ready() -> void:
	_levelTasksStrategy.register_spawner(self, true)
	BarTable.on_item_recieved.connect(_item_recieved)
	
	_npc = _npcsProvider.get_npc(npcName)
	add_child(_npc)
	_npc.rotation_degrees = -90
	progress_ratio = 1
	_npc.on_task_lose.connect(_task_failed)


func start_task(task : TaskModel):
	_task = task
	_levelTasksStrategy.lastStartedTask = task
	BarTable.taskItem = _task.get_item().resource_name
	_npc.Bubble.set_item_name(ItemsProvider.get_item_name(task.item))
	_end_moving()

func _item_recieved():
	BarTable.remove_item()
	_levelTasksStrategy.complete_task(_task, _npc.Bubble.ProgressSlider.value)
	on_order_finished.emit("Kayori received her drink")
	_npc.end_task()

func _task_failed():
	_npc.hide_bubble()
	BarTable.taskItem = ""
	_levelTasksStrategy.lose_task(_task)
	on_order_finished.emit("Kayori did not received her drink on time")
	_complete_task()

func _end_moving():
	if (_npc == null): return
	_npc.Animator.play("Idle")
	_npc.start_task(_task)
	_dialogsProvider.try_start_dialog(_task.entranceDialogId, func(): )
	EventsProvider.call_event("Kayori wants %s" % ItemsProvider.get_item_name(_task.get_item().resource_name))
