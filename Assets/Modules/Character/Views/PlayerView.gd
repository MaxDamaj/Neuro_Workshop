extends CharacterBody2D
class_name PlayerView

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

@export var root : Node2D
@export var animator : AnimationPlayer

@export var itemSprite : Sprite2D
@export var itemInfo : Control

enum State {IDLE, RUN, IDLE_BACKWARD, RUN_BACKWARD, DEFEAT}

var id : int
var speed : float = 384
var can_move : bool = true
var state : PlayerView.State = PlayerView.State.IDLE

var itemName : String:
	set(value):
		itemInfo.tooltip_text = ItemsProvider.get_item_name(value)
		itemName = value
	get:
		return itemName


func _ready():
	animator.speed_scale = 1.5
	animator.play("Idle")

func _physics_process(_delta):
	if (state == State.DEFEAT):
		return;
	
	var newState = State.IDLE_BACKWARD if state == State.RUN_BACKWARD || state == State.IDLE_BACKWARD else State.IDLE
	
	#move horizontal
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	if direction_horizontal:
		velocity.x = direction_horizontal * speed
		root.scale = Vector2(1 if direction_horizontal < 0 else -1, 1)
		newState = State.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#move vertical
	var direction_vertical = Input.get_axis("ui_up", "ui_down")
	if direction_vertical:
		velocity.y = direction_vertical * speed
		newState = State.RUN if direction_vertical > 0 else State.RUN_BACKWARD
	else:
		velocity.y = move_toward(velocity.y, 0, speed);
	
	velocity = velocity.normalized() * speed
	move_and_slide()
	_set_animation(newState)


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

func _set_animation(newState : PlayerView.State):
	if (newState == state): return
	state = newState
	
	match state:
		State.DEFEAT: animator.play("Death")
		State.RUN: animator.play("Run");
		State.RUN_BACKWARD: animator.play("RunBack");
		State.IDLE: animator.play("Idle");
		State.IDLE_BACKWARD: animator.play("IdleBack");
