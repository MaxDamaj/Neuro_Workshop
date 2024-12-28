extends Node
class_name DecorAutomaticMachineView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var ItemSprite : Sprite2D
@export var HoverButton : Button
@export var InteractArea : Area2D

@export var MachineName : String
@export var ProgressSlider : Slider

var itemName : String
var itemToProduce : String

var _player : PlayerView
var _time : float


func _ready() -> void:
	ProgressSlider.visible = false
	_init_buttons()

func _process(delta: float) -> void:
	if (Input.is_action_pressed("action") || HoverButton.button_pressed):
		if (_time <= 0): _try_interact_with_item()
	
	if (_time > 0):
		ProgressSlider.value = ProgressSlider.max_value - _time
		_time -= delta
		if (_time <= 0):
			ItemSprite.texture = _itemsProvider.allItems[itemToProduce].texture


func _init_buttons():
	InteractArea.body_entered.connect(_on_area_2d_body_entered)
	InteractArea.body_exited.connect(_on_area_2d_body_exited)
	HoverButton.visible = false
	HoverButton.disabled = true

func _try_interact_with_item():
	if (_player == null): return
	
	if (itemName == "" && _player.itemName != ""):
		var item : ItemModel = _itemsProvider.allItems[_player.itemName]
		if (!item.usedIn.has(MachineName)): return
		
		var newItem : ItemModel = _itemsProvider.allItems[item.usedIn[MachineName]]
		_add_item(_player.itemName)
		_player.remove_item()
		ProgressSlider.visible = true
		ProgressSlider.max_value = newItem.producingTime
		_time = newItem.producingTime
		itemToProduce = newItem.resource_name
		return
	
	if (itemName != "" && _player.itemName == ""):
		_processing_done()

func _add_item(newItemName : String):
	itemName = newItemName
	ItemSprite.texture = _itemsProvider.allItems[newItemName].texture

func _remove_item():
	itemName = ""
	itemToProduce = ""
	ItemSprite.texture = null

func _processing_done():
	_player.add_item(itemToProduce)
	_remove_item()
	ProgressSlider.visible = false


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
