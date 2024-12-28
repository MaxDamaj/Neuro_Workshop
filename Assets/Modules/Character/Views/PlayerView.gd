extends CharacterBody2D
class_name PlayerView

@onready var _itemsProvider : ItemsProvider = get_node(ItemsProvider.path)

@export var root : Node2D
@export var animator : AnimationPlayer

@export var bodySprite : Sprite2D
@export var hairSprite : Sprite2D
@export var chestSprite : Sprite2D
@export var legsSprite : Sprite2D
@export var itemSprite : Sprite2D

enum State {IDLE, RUN, DEFEAT}

var id : int
var speed : float = 96
var can_move : bool = true
var state : PlayerView.State = PlayerView.State.IDLE
var idle_anim : int
var itemName : String

var _gender_shift : float
var _hair_idle_offset = Vector2(0, -20)
var _hair_crouch_offset = Vector2(2, -12)
var _is_crouch : bool


func _ready():
	idle_anim = 0
	animator.play("Idle")

func _physics_process(_delta):
	if (state == State.DEFEAT):
		return;
	
	var newState = State.IDLE
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	
	#move horizontal
	if direction_horizontal:
		velocity.x = direction_horizontal * speed
		root.scale = Vector2(-1 if direction_horizontal < 0 else 1, 1)
		newState = State.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#move vertical
	var direction_vertical = Input.get_axis("ui_up", "ui_down")
	if direction_vertical:
		velocity.y = direction_vertical * speed
		newState = State.RUN
	else:
		velocity.y = move_toward(velocity.y, 0, speed);
	
	move_and_slide()
	_set_animation(newState)


func try_pickup_item(table : DecorTableView) -> bool:
	if (itemName != ""): return false;
	add_item(table.ItemName)
	table.remove_item()
	return true

func try_place_item(table : DecorTableView) -> bool:
	if (itemName == ""): return false;
	if (table.try_add_item(itemName)):
		remove_item()
	return true

func add_item(newItemName : String):
	var item : ItemModel = _itemsProvider.allItems[newItemName]
	itemName = item.resource_name
	itemSprite.texture = item.texture

func remove_item():
	itemName = ""
	itemSprite.texture = null


func set_animation_idle_frame(_frame):
	var anim_shift = 7 if _is_crouch else idle_anim 
	bodySprite.region_rect.position = Vector2(43 * anim_shift, _gender_shift)
	hairSprite.offset = _hair_idle_offset if !_is_crouch else _hair_crouch_offset
	chestSprite.region_rect.position = Vector2(43 * anim_shift, _gender_shift)
	legsSprite.region_rect.position = Vector2(43 * anim_shift, _gender_shift)

func set_animation_run_frame(frame : int):
	bodySprite.region_rect.position = Vector2(43 * frame, 40 + _gender_shift)
	hairSprite.offset = _hair_idle_offset
	
	chestSprite.region_rect.position = Vector2(43 * frame, 40 + _gender_shift)
	legsSprite.region_rect.position = Vector2(43 * frame, 40 + _gender_shift)

func _set_animation(newState : PlayerView.State):
	if (newState == state): return
	state = newState
	
	if state == PlayerView.State.DEFEAT:
		animator.play("Death")
	if state == PlayerView.State.RUN:
		animator.play("Run");
	if state == PlayerView.State.IDLE:
		animator.play("Idle");
