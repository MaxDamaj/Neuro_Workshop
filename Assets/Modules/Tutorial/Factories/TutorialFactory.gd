extends Node
class_name TutorialFactory

static var path : NodePath = "/root/MainScene/_Factories/TutorialFactory"

@export var tutorials : Dictionary

var _activeTutorial : Node2D


func spawn_tutorial(levelId : int):
	if (tutorials.has(levelId)):
		unload_tutorial()
		var tutorial : Node2D = tutorials[levelId].instantiate()
		var root = get_node("/root/MainScene")
		root.add_child.call_deferred(tutorial)

func unload_tutorial():
	if (_activeTutorial != null):
		_activeTutorial.queue_free()