extends Node
class_name DecorAutomaticMachineView

@export var ItemSprite : Sprite2D
@export var HoverButton : Button
@export var InteractArea : Area2D

@export var MachineName : String
@export var ProgressSlider : Slider

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
			ItemSprite.texture = ItemsProvider.get_item(itemToProduce).texture
			EventsProvider.call_event("%s has finished making %s" % [name, ItemsProvider.get_item_name(itemToProduce)])


func _init_buttons():
	InteractArea.body_entered.connect(_on_area_2d_body_entered)
	InteractArea.body_exited.connect(_on_area_2d_body_exited)
	HoverButton.visible = false
	HoverButton.disabled = true

func _try_interact_with_item():
	if (_player == null): return
	
	if (_time > 0):
		EventsProvider.call_event("%s has not finished its task yet" % name)
		return
	
	if (itemName == "" && _player.itemName != ""):
		var item : ItemModel = ItemsProvider.get_item(_player.itemName)
		if (!item.usedIn.has(MachineName)): return
		
		var newItem : ItemModel = ItemsProvider.get_item(item.usedIn[MachineName])
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
	ItemSprite.texture = ItemsProvider.get_item(newItemName).texture
	EventsProvider.call_event("%s placed at %s" % [ItemsProvider.get_item_name(itemName), name])

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
