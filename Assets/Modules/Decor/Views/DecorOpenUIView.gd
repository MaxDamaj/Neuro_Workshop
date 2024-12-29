extends Node
class_name DecorOpenUIView

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var PanelId : String
@export var HoverButton : Button
@export var InteractArea : Area2D

var _player : PlayerView


func _ready() -> void:
	_init_buttons()

func _input(event):
	if (event.is_action_pressed("action")):
		_open_panel()


func _open_panel():
	if (_player == null): return
	_uiPanelsProvider.open_panel(PanelId)

func _close_panel():
	_uiPanelsProvider.close_panel(PanelId)

func _init_buttons():
	InteractArea.body_entered.connect(_on_area_2d_body_entered)
	InteractArea.body_exited.connect(_on_area_2d_body_exited)
	HoverButton.button_down.connect(_open_panel)
	HoverButton.visible = false
	HoverButton.disabled = true


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
	_close_panel()
