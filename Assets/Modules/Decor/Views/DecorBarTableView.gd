extends DecorTableView
class_name DecorBarTableView

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)

@export var barTableId : int


func try_add_item(itemName : String) -> bool:
	if (ItemName != ""): return false
	if (_levelTasksStrategy.try_complete_task(itemName, barTableId)):
		ItemName = itemName
		ItemSprite.texture = _itemsProvider.allItems[ItemName].texture
		return true
	return false


func _try_interact_with_item():
	if (_player == null): return
	
	if (ItemName == "" && _player.itemName != ""):
		_player.try_place_item(self)
