extends TutorialMarkView
class_name TutorialEventMarkView

@export var eventName : StringName

func _ready() -> void:
	super._ready()
	EventsProvider.subscribe(eventName, _activate_next_mark)
