extends Node
class_name UIInventoryPanel

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

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
		var item : ItemModel = ItemsProvider.get_item(itemName)
		CellsContainer.add_child(tile)
		
		tile.TileIcon.texture = item.texture
		tile.TileButton.button_down.connect(func(): _add_item(itemName))

func _add_item(itemName : String):
	if (_player.itemName != ""):
		if (_player.itemName == itemName):
			_player.remove_item()
	else:
		_player.add_item(itemName)
		_soundProvider.play_sound("pick_up")
		UIPanelsProvider.close_panel("inventory_ui")
