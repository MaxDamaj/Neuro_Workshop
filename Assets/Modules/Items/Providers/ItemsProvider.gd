extends BaseProvider
class_name ItemsProvider

static var _instance : ItemsProvider

var allItems : Dictionary


func _ready() -> void:
	_instance = self
	_add_to_dictionary("res://Assets/Modules/Items/Assets/Items", allItems)


static func get_all_items_names() -> PackedStringArray:
	return PackedStringArray(_instance.allItems.keys())

static func get_item(itemId : String) -> ItemModel:
	if (_instance == null): return null
	
	if (!_instance.allItems.has(itemId)): return _instance.allItems["banana"]
	return _instance.allItems[itemId]

static func get_item_name(itemId : String) -> String:
	if (itemId == ""): return itemId
	if (_instance == null): return itemId.replace('_', ' ')
	
	var item : ItemModel = get_item(itemId)
	if (item.name != ""): return item.name
	return item.resource_name.replace('_', ' ')

static func get_item_recipe(itemId : String) -> String:
	if (_instance == null): return ""
	
	var item : ItemModel = get_item(itemId)
	if (item.recipe != ""): return item.recipe
	return "unknown recipe"
