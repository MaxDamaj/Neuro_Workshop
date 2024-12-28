extends Node
class_name UIInventoryPanel

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var CellsContainer : Control
@export var CellPrefab : PackedScene

var _player : PlayerView
var _itemsList : Array[String]


func _ready() -> void:
	_fill_inventory()

func init_args(args : Dictionary):
	if args.has("player"):
		_player = args["player"]
	if args.has("items"):
		_itemsList = args["items"]


func _fill_inventory():
	for itemName in _itemsList:
		var tile : TileView = CellPrefab.instantiate()
		var item : ItemModel = _itemsProvider.allItems[itemName]
		CellsContainer.add_child(tile)
		
		tile.TileIcon.texture = item.texture
		tile.TileButton.button_down.connect(func(): _add_item(itemName))

func _add_item(itemName : String):
	if (_player.itemName != ""):
		if (_player.itemName == itemName):
			_player.remove_item()
	else:
		_player.add_item(itemName)
		_uiPanelsProvider.close_panel("inventory_ui")
