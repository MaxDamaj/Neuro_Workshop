extends Node
class_name DecorManualMachineView

@export var ItemSprite : Sprite2D
@export var HoverButton : Button
@export var InteractArea : Area2D

@export var MachineName : String
@export var ProgressSlider : Slider

signal on_item_produced(machine : DecorManualMachineView)

var aiProcessing : bool
var itemToProduce : String
var itemName : String:
	set(value):
		if (HoverButton != null):
			HoverButton.tooltip_text = ItemsProvider.get_item_name(value)
		itemName = value
	get:
		return itemName

var _player : CharacterView
var _time : float
var _can_process : bool


func _ready() -> void:
	ProgressSlider.visible = false
	_init_buttons()

func _process(delta: float) -> void:
	if (Input.is_action_pressed("action") || HoverButton.button_pressed || aiProcessing):
		if (_player == null): return
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

func _try_interact_with_item() -> bool:
	if (_player == null): return false
	if (itemName == "" && _player.itemName != ""):
		var item : ItemModel = ItemsProvider.get_item(_player.itemName)
		if (!item.usedIn.has(MachineName)):
			EventsProvider.call_event("cannot use %s on %s" % [ItemsProvider.get_item_name(_player.itemName), name])
			return false
		
		var newItem : ItemModel = ItemsProvider.get_item(item.usedIn[MachineName])
		_add_item(_player.itemName)
		_player.remove_item()
		ProgressSlider.visible = true
		ProgressSlider.max_value = newItem.producingTime
		_time = newItem.producingTime
		itemToProduce = newItem.resource_name
		return true
	return false

func _add_item(newItemName : String):
	itemName = newItemName
	ItemSprite.texture = ItemsProvider.get_item(newItemName).texture
	EventsProvider.call_event("manual creating %s at %s, please wait..." % [ItemsProvider.get_item_name(newItemName), name])

func _remove_item():
	itemName = ""
	itemToProduce = ""
	ItemSprite.texture = null

func _processing_done():
	EventsProvider.call_event("finish making %s" % ItemsProvider.get_item_name(itemToProduce))
	_player.add_item(itemToProduce)
	_remove_item()
	ProgressSlider.visible = false
	on_item_produced.emit(self)


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
