extends Node
class_name DecorManualMachineView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var ItemSprite : Sprite2D
@export var HoverButton : Button
@export var InteractArea : Area2D

@export var MachineName : String
@export var ProgressSlider : Slider

var itemToProduce : String
var itemName : String:
	set(value):
		if (HoverButton != null):
			HoverButton.tooltip_text = value.replace("_", " ")
		itemName = value
	get:
		return itemName

var _player : PlayerView
var _time : float
var _can_process : bool


func _ready() -> void:
	ProgressSlider.visible = false
	_init_buttons()

func _process(delta: float) -> void:
	if (Input.is_action_pressed("action") || HoverButton.button_pressed):
		if (_time > 0):
			if (itemName != "" && _player.itemName == ""): _can_process = true
		else:
			_try_interact_with_item()
	else:
		_can_process = false
	
	
	if (!_can_process): return
	
	if (_time > 0):
		ProgressSlider.value = ProgressSlider.max_value - _time
		_time -= delta
		if (_time <= 0):
			_processing_done()


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
