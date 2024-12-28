extends Node
class_name LevelTasksStrategy

static var path : NodePath = "/root/MainScene/_Strategies/LevelTasksStrategy"


func _ready() -> void:
	pass # Replace with function body.


func try_complete_task(itemName : String, tableId : int) -> bool:
	return true
