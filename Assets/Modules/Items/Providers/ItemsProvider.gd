extends BaseProvider
class_name ItemsProvider

static var path : NodePath = "/root/MainScene/_Providers/ItemsProvider"

var allItems : Dictionary

func _ready() -> void:
	_add_to_dictionary("res://Assets/Modules/Items/Assets", allItems)
