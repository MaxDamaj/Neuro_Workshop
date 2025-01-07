extends TutorialMarkView
class_name TutorialAreaMarkView

@export var area : Area2D


func _ready() -> void:
	super._ready()
	area.body_entered.connect(_on_area_2d_body_entered)


func _on_area_2d_body_entered(body : Node2D):
	if (timeToDeactivation > 0): return
	if (!body.is_in_group("Player")): return
	_activate_next_mark()
