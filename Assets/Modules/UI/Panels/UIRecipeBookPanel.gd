extends Node
class_name UIRecipeBookPanel

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)
@onready var _levelLoadStrategy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)
@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)

@export var Pages : Array[Panel]
@export var ReturnButton : Button
@export var NextButton : Button
@export var PrevButton : Button
@export var PageCounter1 : Label
@export var PageCounter2 : Label
@export var SafeCode : Label

static var currentPage : int = 1
static var codePage : int = 4

func _ready() -> void:
	SafeCode.get_parent().visible = false
	SafeCode.text = str(_levelLoadStrategy.safeCode).pad_zeros(4)
	
	_show_page(currentPage)
	
	if (currentPage == Pages.size()):
		NextButton.disabled = true
		NextButton.visible = false
	else:
		NextButton.disabled = false
		NextButton.visible = true
	if(currentPage == 1):
		PrevButton.disabled = true
		PrevButton.visible = false
	else:
		PrevButton.disabled = false
		PrevButton.visible = true
		
	ReturnButton.button_down.connect(_close_recipe_book)
	NextButton.button_down.connect(_next_page)
	PrevButton.button_down.connect(_prev_page)
	
	var item : ItemModel = _levelTasksStrategy.lastStartedTask.get_item()
	EventsProvider.call_event("To create %s you need to %s" % [item.name, item.recipe])

func _close_recipe_book() -> void:
	UIPanelsProvider.close_panel("recipe_book_ui")

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
	if (currentPage<=1):
		PrevButton.disabled = true
		PrevButton.visible = false
	_show_page(currentPage)

func _show_page(pageNumber: int) -> void:
	_soundProvider.play_sound("book_pages")
	
	PageCounter1.text = "Pages "+str(pageNumber*2-1)+"/"+str(Pages.size()*2)
	PageCounter2.text = "Pages "+str(pageNumber*2)+"/"+str(Pages.size()*2)
	for i in range(Pages.size()):
		Pages[i].visible = false
	Pages[pageNumber-1].visible = true
	if (currentPage == codePage):
		SafeCode.get_parent().visible = true
	else:
		SafeCode.get_parent().visible = false
