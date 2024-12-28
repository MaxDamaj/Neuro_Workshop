extends DecorTableView
class_name DecorGeneratorView

@export var baseItem : String

func _ready() -> void:
	_init_buttons()

func try_add_item(itemName : String):
	return true

func remove_item():
	pass

func _try_interact_with_item():
	if (_player == null): return
	
	if (ItemName != ""):
		if (ItemName == _player.itemName):
			_player.try_place_item(self)
		else:
			_player.try_pickup_item(self)
