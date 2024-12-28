extends Node
class_name DecorTableView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var ItemSprite : Sprite2D
@export var HoverButton : Button
@export var InteractArea : Area2D

@export var ItemName : String

var _player : PlayerView


func _ready() -> void:
	if (ItemName != ""):
		ItemSprite.texture = _itemsProvider.allItems[ItemName].texture
	
	_init_buttons()

func _input(event):
	if (event.is_action_pressed("action")):
		_try_interact_with_item()


func add_item(itemName : String):
	ItemName = itemName
	ItemSprite.texture = _itemsProvider.allItems[ItemName].texture

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
		_player.try_pickup_item(self)


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
