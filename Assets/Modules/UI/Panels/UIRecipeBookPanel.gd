extends Node
class_name UIRecipeBookPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var Pages : Array[Panel]
@export var ReturnButton : Button
@export var NextButton : Button
@export var PrevButton : Button

var currentPage : int

func _ready() -> void:
	currentPage = 1
	_show_page(currentPage)
	PrevButton.disabled = true
	PrevButton.visible = false
	
	ReturnButton.button_down.connect(func(): _uiPanelsProvider.close_panel("recipe_book_ui"))
	NextButton.button_down.connect(_next_page)
	PrevButton.button_down.connect(_prev_page)

func _next_page()->void:
	PrevButton.disabled = false
	PrevButton.visible = true
	currentPage+=1
	if (currentPage>=Pages.size()):
		NextButton.disabled = true
		NextButton.visible = false
	_show_page(currentPage)
	
func _prev_page()->void:
	NextButton.disabled = false
	NextButton.visible = true
	currentPage-=1
	if (currentPage<1):
		PrevButton.disabled = true
		PrevButton.visible = false
	_show_page(currentPage)

func _show_page(pageNumber: int) -> void:
	for i in range(Pages.size()):
		Pages[i].visible = false
	Pages[pageNumber-1].visible = true
