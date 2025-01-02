extends CharacterBody2D
class_name CharacterView

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

@export var animator : AnimationPlayer
@export var root : Node2D
@export var itemSprite : Sprite2D
@export var itemInfo : Control

enum State {IDLE, RUN, IDLE_BACKWARD, RUN_BACKWARD, DEFEAT}

var speed : float = 384
var can_move : bool = true
var state : CharacterView.State = CharacterView.State.IDLE

var itemName : String:
	set(value):
		itemInfo.tooltip_text = ItemsProvider.get_item_name(value)
		itemName = value
	get:
		return itemName


func _ready():
	animator.speed_scale = 1.5
	animator.play("Idle")

func try_pickup_item(table : DecorTableView) -> bool:
	if (itemName != ""): return false;
	add_item(table.ItemName)
	table.remove_item()
	_soundProvider.play_sound("pick_up")
	return true

func try_place_item(table : DecorTableView) -> bool:
	if (itemName == ""): return false;
	if (table.try_add_item(itemName)):
		remove_item()
	return true

func add_item(newItemName : String):
	var item : ItemModel = ItemsProvider.get_item(newItemName)
	itemName = item.resource_name
	itemSprite.texture = item.texture
	EventsProvider.call_event("%s picked up" % ItemsProvider.get_item_name(newItemName))

func remove_item():
	itemName = ""
	itemSprite.texture = null

func _set_animation(newState : CharacterView.State):
	if (newState == state): return
	state = newState
	
	match state:
		State.DEFEAT: animator.play("Death")
		State.RUN: animator.play("Run");
		State.RUN_BACKWARD: animator.play("RunBack");
		State.IDLE: animator.play("Idle");
		State.IDLE_BACKWARD: animator.play("IdleBack");
