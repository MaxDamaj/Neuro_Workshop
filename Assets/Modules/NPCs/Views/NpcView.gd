extends Node2D
class_name NpcView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var Animator : AnimationPlayer
@export var Bubble : TileBubble

signal on_task_lose

var _tween : Tween

func _ready() -> void:
	Animator.speed_scale = randf_range(0.8, 1.4)
	Bubble.visible = false

func _exit_tree() -> void:
	if (_tween != null): _tween.kill()


func start_task(task : TaskModel):
	_show_bubble()
	_start_waiting_time(task.waitingTime)
	Bubble.OrderIcon.texture = _itemsProvider.allItems[task.items[0]].texture

func end_task():
	hide_bubble()
	if (_tween != null): _tween.kill()

func _show_bubble() -> void:
	Bubble.visible = true
	Bubble.scale = Vector2.ZERO
	
	var tween = create_tween()
	var target_scale = Vector2.ONE
	tween.tween_property(Bubble, "scale", target_scale, 0.5)
	tween.tween_callback(func(): Bubble.scale = target_scale)

func _start_waiting_time(maxValue : float) -> void:
	Bubble.ProgressSlider.max_value = maxValue
	Bubble.ProgressSlider.value = maxValue
	
	if (_tween != null): _tween.kill()
	_tween = create_tween()
	_tween.tween_property(Bubble.ProgressSlider, "value", 0, maxValue)
	_tween.tween_callback(func(): on_task_lose.emit())

func hide_bubble() -> void:
	Bubble.visible = true
	Bubble.scale = Vector2.ONE
	
	var tween = create_tween()
	var target_scale = Vector2.ZERO
	tween.tween_property(Bubble, "scale", target_scale, 0.5)
	tween.tween_callback(func(): 
		Bubble.scale = target_scale
		Bubble.visible = false
	)

func _lose_task():
	on_task_lose.emit()
