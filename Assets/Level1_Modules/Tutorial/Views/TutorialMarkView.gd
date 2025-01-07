extends Node2D
class_name TutorialMarkView

@export var nextMark : TutorialMarkView
@export var animator : AnimationPlayer

@export var timeToActivation : float
@export var timeToDeactivation : float
@export var autoActivation : bool

func _ready() -> void:
	process_mode = PROCESS_MODE_DISABLED
	visible = false
	
	if (autoActivation): activate_mark()
	if (animator != null):
		animator.play("Idle")


func activate_mark():
	if (timeToActivation > 0):
		await get_tree().create_timer(timeToActivation, false).timeout
	
	process_mode = PROCESS_MODE_INHERIT
	visible = true
	
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	var target_color = Color.WHITE
	tween.tween_property(self, "modulate", target_color, 0.5)
	
	if (timeToDeactivation > 0):
		await get_tree().create_timer(timeToDeactivation, false).timeout
		_activate_next_mark()

func _activate_next_mark():
	var tween = create_tween()
	var target_color = Color(1, 1, 1, 0)
	tween.tween_property(self, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		queue_free()
	)
	
	if (nextMark == null): return
	nextMark.activate_mark()
