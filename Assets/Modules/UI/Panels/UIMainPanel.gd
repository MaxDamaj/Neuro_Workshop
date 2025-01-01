extends CanvasLayer
class_name UIMainPanel

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)
@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

@export var MainContainer : Control
@export var NewGameButton : Button
@export var ChooseLevelButton : Button
@export var ExtraButton : Button
@export var SettingsButton : Button

@export var BackButton : Button
@export var LevelButtons : Array[Button]
@export var EffectsVolumeSlider : HSlider
@export var MusicVolumeSlider: HSlider

@export_group("Extra")
@export var ExtraContainer : Control
@export var FreeGameButton : Button
@export var NeuroBartenderButton : Button

const BUTTON_HIDDEN_X = -550
const BUTTON_SHOWN_X = 100
const SLIDER_HIDDEN_X = -700
const SLIDER_SHOWN_X = 100
const BACK_BUTTON_SHOWN_X = 50

var currentMenu : String

func _ready() -> void:
	for i in range(LevelButtons.size()):
		LevelButtons[i].button_down.connect(func(): _load_level(i))
		LevelButtons[i].disabled = i > _levelLoadStartegy.lastUnlockedLevel
	
	NewGameButton.button_down.connect(func(): _load_level(0))
	ChooseLevelButton.button_down.connect(_show_level_buttons)
	BackButton.button_down.connect(_show_main_buttons)
	SettingsButton.button_down.connect(_show_settings_buttons)
	
	EffectsVolumeSlider.value = _soundProvider.soundVolume
	MusicVolumeSlider.value = _soundProvider.musicVolume
	EffectsVolumeSlider.value_changed.connect(func(value : float): _soundProvider.soundVolume = value)
	MusicVolumeSlider.value_changed.connect(func(value : float): _soundProvider.musicVolume = value)
	
	currentMenu = 'main'
	_hide_level_buttons()
	_show_main_buttons()
	
	_soundProvider.play_music("main_theme")


func _load_level(levelId : int):
	_levelLoadStartegy.load_level(levelId)

func _move_ui_element(element : Control, x : int, y : int) -> void:
	element.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = create_tween()
	var target_pos = Vector2 (x,y)
	
	tween.tween_property(element, "position", target_pos,0.3)
	tween.tween_callback(
	func():
		element.position = target_pos
		element.mouse_filter = Control.MOUSE_FILTER_STOP
	)

func _hide_button(ButtonElement:Button) -> void:
	_move_ui_element(ButtonElement, BUTTON_HIDDEN_X, ButtonElement.position.y)
	ButtonElement.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _show_button(ButtonElement:Button) -> void:
	_move_ui_element(ButtonElement, BUTTON_SHOWN_X, ButtonElement.position.y)
	ButtonElement.mouse_filter = Control.MOUSE_FILTER_STOP

func _hide_back_button() -> void:
	_move_ui_element(BackButton, BUTTON_HIDDEN_X, BackButton.position.y)
	BackButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _show_back_button() -> void:
	_move_ui_element(BackButton, BACK_BUTTON_SHOWN_X, BackButton.position.y)
	BackButton.mouse_filter = Control.MOUSE_FILTER_STOP

func _hide_slider(SliderElement:HSlider) -> void:
	_move_ui_element(SliderElement, SLIDER_HIDDEN_X, SliderElement.position.y)
	SliderElement.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _show_slider(SliderElement:HSlider) -> void:
	_move_ui_element(SliderElement, SLIDER_SHOWN_X, SliderElement.position.y)
	SliderElement.mouse_filter = Control.MOUSE_FILTER_STOP


func _hide_main_buttons() -> void:
	_move_ui_element(MainContainer, BUTTON_HIDDEN_X, MainContainer.position.y)
	
func _show_main_buttons() -> void:
	_move_ui_element(MainContainer, BUTTON_SHOWN_X, MainContainer.position.y)
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
