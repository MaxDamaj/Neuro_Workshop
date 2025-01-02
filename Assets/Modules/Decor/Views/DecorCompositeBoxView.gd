extends Node
class_name DecorCompositeBoxView

@export var HoverButton : Button
@export var InteractArea : Area2D
@export var ItemsList : Array[String]

var _player : CharacterView

func _ready() -> void:
	_init_buttons()

func _input(event):
	if (event.is_action_pressed("action")):
		_try_interact_with_item()


func _init_buttons():
	InteractArea.body_entered.connect(_on_area_2d_body_entered)
	InteractArea.body_exited.connect(_on_area_2d_body_exited)
	HoverButton.button_down.connect(_try_interact_with_item)
	HoverButton.visible = false
	HoverButton.disabled = true

func _try_interact_with_item():
	if (_player == null): return
	UIPanelsProvider.open_panel_with_args("inventory_ui", {"items" : ItemsList, "player" : _player})


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
	UIPanelsProvider.close_panel("inventory_ui")
