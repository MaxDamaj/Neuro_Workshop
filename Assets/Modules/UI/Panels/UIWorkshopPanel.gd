extends CanvasLayer
class_name UIWorkshopPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var BackButton : Button

func _ready() -> void:
	BackButton.button_down.connect(_try_close_level)


func _try_close_level():
	_uiPanelsProvider.open_panel("exit_level_ui")
