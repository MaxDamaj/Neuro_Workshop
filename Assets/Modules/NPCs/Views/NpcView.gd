extends Node2D
class_name NpcView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var Animator : AnimationPlayer

@export var Bubble : Control
@export var OrderIcon : TextureRect
@export var ProgressSlider : Slider

signal on_task_lose


func _ready() -> void:
	Bubble.visible = false


func start_task(task : TaskModel):
	show_bubble()
	OrderIcon.texture = _itemsProvider.allItems[task.items[0]].texture
	ProgressSlider.max_value = task.waitingTime
	ProgressSlider.value = task.waitingTime

func show_bubble() -> void:
	Bubble.visible = true
	Bubble.scale = Vector2.ZERO
	
	var tween = create_tween()
	var target_scale = Vector2.ONE
	tween.tween_property(Bubble, "scale", target_scale, 0.5)
	tween.tween_callback(func(): Bubble.scale = target_scale)

func _lose_task():
	on_task_lose.emit()
