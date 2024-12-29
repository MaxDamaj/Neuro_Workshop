extends Node
class_name DecorTableView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var ItemSprite : Sprite2D
@export var HoverButton : Button
@export var InteractArea : Area2D

var ItemName : String:
	set(value):
		if (HoverButton != null):
			HoverButton.tooltip_text = value.replace("_", " ")
		ItemName = value
	get:
		return ItemName

var _player : PlayerView


func _ready() -> void:
	if (ItemName != ""):
		ItemSprite.texture = _itemsProvider.allItems[ItemName].texture
	
	_init_buttons()

func _input(event):
	if (event.is_action_pressed("action")):
		_try_interact_with_item()


func try_add_item(itemName : String) -> bool:
	ItemName = itemName
	ItemSprite.texture = _itemsProvider.allItems[ItemName].texture
	return true

func remove_item():
	ItemName = ""
	ItemSprite.texture = null


func _init_buttons():
	InteractArea.body_entered.connect(_on_area_2d_body_entered)
	InteractArea.body_exited.connect(_on_area_2d_body_exited)
	HoverButton.button_down.connect(_try_interact_with_item)
	HoverButton.visible = false
	HoverButton.disabled = true

func _try_interact_with_item():
	if (_player == null): return
	
	if (ItemName == ""):
		_player.try_place_item(self)
	else:
		if (_try_merge_items(_player.itemName)): return
		_player.try_pickup_item(self)

func _try_merge_items(itemToMerge : String) -> bool:
	if (itemToMerge == ""): return false
	var mergeItem : ItemModel = _itemsProvider.allItems[itemToMerge]
	
	if (mergeItem.mergeTo.has(ItemName)):
		if (try_add_item(mergeItem.mergeTo[ItemName])):
			_player.remove_item()
		return true
	
	return false


func _on_area_2d_body_entered(body : Node2D):
	if (!body.is_in_group("Player")): return
	
	_player = body
	HoverButton.visible = true
	HoverButton.disabled = false

func _on_area_2d_body_exited(body):
	if (!body.is_in_group("Player")): return
	
	_player = null
	HoverButton.visible = false
	HoverButton.disabled = true
