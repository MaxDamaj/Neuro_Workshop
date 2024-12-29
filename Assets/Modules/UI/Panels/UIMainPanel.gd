extends CanvasLayer
class_name UIMainPanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var NewGameButton : Button
@export var ChooseLevelButton : Button
@export var BackButton : Button
@export var LevelButtons : Array[Button]
@export var SettingsButton : Button
@export var EffectsVolumeSlider : HSlider
@export var MusicVolumeSlider: HSlider

var BUTTON_HIDDEN_X = -400
var BUTTON_SHOWN_X = 100
var SLIDER_HIDDEN_X = -700
var SLIDER_SHOWN_X = 100
var BACK_BUTTON_SHOWN_X = 50

var currentMenu : String

func _ready() -> void:
	for i in range(LevelButtons.size()):
		LevelButtons[i].button_down.connect(func(): _load_level(i))
		
	NewGameButton.button_down.connect(func(): _load_level(0))
	ChooseLevelButton.button_down.connect(_show_level_buttons)
	BackButton.button_down.connect(_show_main_buttons)
	SettingsButton.button_down.connect(_show_settings_buttons)
	currentMenu = 'main'
	_hide_level_buttons()
	_show_main_buttons()


func _load_level(levelId : int):
	_levelLoadStartegy.load_level(levelId)
	
func _move_button(ButtonElement:Button, x:int, y:int) -> void:
	var disableState : bool = ButtonElement.disabled
	
	ButtonElement.disabled = true
	var tween = create_tween()
	var target_pos = Vector2 (x,y)
	tween.tween_property(ButtonElement, "position", target_pos,0.3)
	tween.tween_callback(
	func():
		ButtonElement.position = target_pos
		ButtonElement.disabled = disableState
	)	
	
func _hide_button(ButtonElement:Button) -> void:
	_move_button(ButtonElement, BUTTON_HIDDEN_X, ButtonElement.position.y)
	ButtonElement.process_mode = Node.PROCESS_MODE_DISABLED
	
func _show_button(ButtonElement:Button) -> void:
	_move_button(ButtonElement, BUTTON_SHOWN_X, ButtonElement.position.y)
	ButtonElement.process_mode = Node.PROCESS_MODE_INHERIT
	
func _hide_back_button() -> void:
	_move_button(BackButton, BUTTON_HIDDEN_X, BackButton.position.y)
	BackButton.process_mode = Node.PROCESS_MODE_DISABLED
	
func _show_back_button() -> void:
	_move_button(BackButton, BACK_BUTTON_SHOWN_X, BackButton.position.y)
	BackButton.process_mode = Node.PROCESS_MODE_INHERIT
	
func _move_slider(SliderElement:HSlider, x:int, y:int) -> void:
	var tween = create_tween()
	var target_pos = Vector2 (x,y)
	tween.tween_property(SliderElement, "position", target_pos,0.3)
	tween.tween_callback(
	func():
		SliderElement.position = target_pos
	)
	
func _hide_slider(SliderElement:HSlider) -> void:
	_move_slider(SliderElement, SLIDER_HIDDEN_X, SliderElement.position.y)
	
func _show_slider(SliderElement:HSlider) -> void:
	_move_slider(SliderElement, SLIDER_SHOWN_X, SliderElement.position.y)

func _hide_main_buttons() -> void:
	_hide_button(ChooseLevelButton)
	_hide_button(NewGameButton)
	_hide_button(SettingsButton)
	
func _show_main_buttons() -> void:
	_show_button(ChooseLevelButton)
	_show_button(NewGameButton)
	_show_button(SettingsButton)
	_hide_back_button()
	if (currentMenu == 'levels'):
		_hide_level_buttons()
	if (currentMenu == 'settings'):
		_hide_settings_buttons()
	currentMenu = 'main'

func _hide_level_buttons() -> void:
	for i in range(LevelButtons.size()):
		_hide_button(LevelButtons[i])

func _show_level_buttons() -> void:
	for i in range(LevelButtons.size()):
		_show_button(LevelButtons[i])
	_show_back_button()
	_hide_main_buttons()
	currentMenu = 'levels'

func _hide_settings_buttons() -> void:
	_hide_slider(EffectsVolumeSlider)
	_hide_slider(MusicVolumeSlider)
	
func _show_settings_buttons() -> void:
	_show_slider(EffectsVolumeSlider)
	_show_slider(MusicVolumeSlider)
	_show_back_button()
	_hide_main_buttons()
	currentMenu = 'settings'
