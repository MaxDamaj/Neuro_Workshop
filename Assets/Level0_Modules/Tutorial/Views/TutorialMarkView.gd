extends Node2D
class_name TutorialMarkView

@export var area : Area2D
@export var label : Label
@export var textInLabel : String
@export var nextMark : TutorialMarkView

@export var timeToDeactivation : float
@export var autoActivation : bool

func _ready() -> void:
	process_mode = PROCESS_MODE_DISABLED
	visible = false
	label.text = textInLabel
	
	area.body_entered.connect(_on_area_2d_body_entered)
	
	if (autoActivation): activate_mark()


func activate_mark():
	process_mode = PROCESS_MODE_INHERIT
	visible = true
	
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	var target_color = Color.WHITE
	tween.tween_property(self, "modulate", target_color, 0.5)
	
	if (timeToDeactivation > 0):
		await get_tree().create_timer(timeToDeactivation).timeout
		_activate_next_mark()


func _on_area_2d_body_entered(body : Node2D):
	if (timeToDeactivation > 0): return
	if (!body.is_in_group("Player")): return
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
