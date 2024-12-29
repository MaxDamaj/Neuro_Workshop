extends Node
class_name UISafePanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)
@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var NumberDisplay : Label
@export var NumberButtons : Array[Button]
@export var DeleteButton : Button
@export var ClearButton : Button
@export var TakeButton : Button
@export var ReturnButton : Button

var currentPosition = 0

func _ready() -> void:
	NumberDisplay.text = "* * * *"
	TakeButton.button_down.connect(_take_item)
	ReturnButton.button_down.connect(func(): _uiPanelsProvider.close_panel("safe_ui"))
	DeleteButton.button_down.connect(_delete_button)
	ClearButton.button_down.connect(_clear_button)
	for i in range(NumberButtons.size()):
		NumberButtons[i].button_down.connect(_get_number_button(i))
	
func _clear_button() -> void:
	NumberDisplay.text = "* * * *"
	currentPosition = 0
	
func _delete_button() -> void:
	if (currentPosition<=0):
		return
	currentPosition-=1
	NumberDisplay.text[currentPosition * 2] = '*'
	
func _input_number(number: int) -> void:
	if (currentPosition > 3):
		return
	NumberDisplay.text[currentPosition * 2] = str(number)
	currentPosition+=1
	
func _get_number_button(number: int) -> Callable:
	var number_button: Callable = func():
		_input_number(number)
	return number_button


func _take_item():
	if (int(NumberDisplay.text) == _levelLoadStartegy.safeCode && currentPosition == 4):
		var player : PlayerView = get_tree().get_nodes_in_group("Player")[0]
		player.add_item("lava_lamp")
		_uiPanelsProvider.close_panel("safe_ui")
