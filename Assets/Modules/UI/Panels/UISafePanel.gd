extends Node
class_name UISafePanel

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)
@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var NumberDisplay : Label
@export var NumberButtons : Array[Button]
@export var DeleteButton : Button
@export var ClearButton : Button
@export var TakeButton : Button
@export var ReturnButton : Button

var RED_COLOR = "#ea8080"
var GREEN_COLOR = "#83af44"
var WHITE_COLOR = "#ffffff"

static var currentPosition = 0
static var displayText  = "_ _ _ _"
var _timer : int
var _isError : bool
var _isSuccess : bool

func _ready() -> void:
	_timer = 0
	_isError = false
	_isSuccess = false

	NumberDisplay.text = displayText
	NumberDisplay.label_settings.font_color = WHITE_COLOR

	TakeButton.button_down.connect(_submit)
	ReturnButton.button_down.connect(func(): _uiPanelsProvider.close_panel("safe_ui"))
	DeleteButton.button_down.connect(_delete_button)
	ClearButton.button_down.connect(_clear_button)
	for i in range(NumberButtons.size()):
		NumberButtons[i].button_down.connect(_get_number_button(i))

	_toggle_buttons(true)

func _clear_button() -> void:
	displayText = "_ _ _ _"
	NumberDisplay.text = displayText
	currentPosition = 0
	
func _delete_button() -> void:
	if (currentPosition<=0):
		return
	currentPosition-=1
	displayText[currentPosition * 2] = '_'
	NumberDisplay.text = displayText
	
func _input_number(number: int) -> void:
	if (currentPosition > 3):
		return
	displayText[currentPosition * 2] = str(number)
	NumberDisplay.text = displayText
	currentPosition+=1
	
func _get_number_button(number: int) -> Callable:
	var number_button: Callable = func():
		_input_number(number)
	return number_button


func _toggle_buttons(state:bool)->void:
	for i in range(NumberButtons.size()):
		NumberButtons[i].disabled = !state
	DeleteButton.disabled = !state
	ClearButton.disabled = !state
	TakeButton.disabled = !state
	ReturnButton.disabled = !state

func _submit():
	_toggle_buttons(false)
	if (int(displayText) == _levelLoadStartegy.safeCode && currentPosition == 4):
		_isSuccess = true
		NumberDisplay.text = "SAFE OPEN"
		NumberDisplay.label_settings.font_color = GREEN_COLOR
	else:
		_isError = true
		NumberDisplay.text = "ERROR"
		NumberDisplay.label_settings.font_color = RED_COLOR


func _take_item():
	var player : PlayerView = get_tree().get_nodes_in_group("Player")[0]
	player.add_item("lava_lamp")
	_soundProvider.play_sound("open_safe")
	_uiPanelsProvider.close_panel("safe_ui")

func _process(delta)->void:
	if (_isError):
		_timer+=1
		if (_timer>60):
			_isError = false
			NumberDisplay.label_settings.font_color = WHITE_COLOR
			_toggle_buttons(true)
			_clear_button()
			_timer = 0
	if (_isSuccess):
		_timer+=1
		if (_timer>60):
			_isSuccess = false
			NumberDisplay.label_settings.font_color = WHITE_COLOR
			_toggle_buttons(true)
			_clear_button()
			_take_item()
			_timer = 0
