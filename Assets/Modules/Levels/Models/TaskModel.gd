extends Resource
class_name TaskModel

@export var npcName : String
@export var delay : float
@export var item : String
@export var waitingTime : float
@export var chillingTime : float
@export var rarity : int
@export var nextTask : TaskModel
@export var completedTasksCount : int
@export var entranceDialogId : String
@export var dialogId : String

func get_item() -> ItemModel:
	return ItemsProvider.get_item(item)
