extends Node
class_name UISettingsPanel

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var CloseSettingsButton : Button
@export var MainMenuButton : Button
@export var EffectsVolumeSlider : HSlider
@export var MusicVolumeSlider: HSlider

var _wasPaused : bool

func _ready() -> void:
	_wasPaused = get_tree().paused
	get_tree().paused = true
	CloseSettingsButton.button_down.connect(_close_panel)
	MainMenuButton.button_down.connect(_try_close_level)
	
	EffectsVolumeSlider.value = _soundProvider.soundVolume
	MusicVolumeSlider.value = _soundProvider.musicVolume
	EffectsVolumeSlider.value_changed.connect(func(value : float): _soundProvider.soundVolume = value)
	MusicVolumeSlider.value_changed.connect(func(value : float): _soundProvider.musicVolume = value)

func _try_close_level():
	_uiPanelsProvider.open_panel("exit_level_ui")
	_uiPanelsProvider.close_panel("settings_ui")

func _close_panel():
	get_tree().paused = _wasPaused
	_uiPanelsProvider.close_panel("settings_ui")
