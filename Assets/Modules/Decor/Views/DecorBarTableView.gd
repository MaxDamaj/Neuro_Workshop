extends DecorTableView
class_name DecorBarTableView

signal on_item_recieved

var taskItem : String

func try_add_item(itemName : String) -> bool:
	if (ItemName != ""): return false
	if (itemName == taskItem):
		ItemName = itemName
		ItemSprite.texture = _itemsProvider.allItems[ItemName].texture
		on_item_recieved.emit()
		return true
	return false

func remove_item():
	ItemSprite.texture = null
	ItemName = ""


func _try_interact_with_item():
	if (_player == null): return
	
	if (ItemName == "" && _player.itemName != ""):
		_player.try_place_item(self)
