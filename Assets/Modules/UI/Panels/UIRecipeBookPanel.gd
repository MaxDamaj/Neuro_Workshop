extends Node
class_name UIRecipeBookPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var ReturnButton : Button


func _ready() -> void:
	ReturnButton.button_down.connect(func(): _uiPanelsProvider.close_panel("recipe_book_ui"))
