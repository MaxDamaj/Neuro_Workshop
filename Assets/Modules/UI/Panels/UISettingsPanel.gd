extends Node
class_name UISettingsPanel

@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

@export var CloseSettingsButton : Button
@export var MainMenuButton : Button
@export var EffectsVolumeSlider : HSlider
@export var MusicVolumeSlider: HSlider

static var wasPaused : bool

func _ready() -> void:
	get_tree().paused = true
	CloseSettingsButton.button_down.connect(_close_panel)
	MainMenuButton.button_down.connect(_try_close_level)
	
	EffectsVolumeSlider.value = _soundProvider.soundVolume
	MusicVolumeSlider.value = _soundProvider.musicVolume
	EffectsVolumeSlider.value_changed.connect(func(value : float): _soundProvider.soundVolume = value)
	MusicVolumeSlider.value_changed.connect(func(value : float): _soundProvider.musicVolume = value)

func _try_close_level():
	UIPanelsProvider.open_panel("exit_level_ui")
	UIPanelsProvider.close_panel("settings_ui")

func _close_panel():
	if (UIPanelsProvider.is_panel_open("dialog_ui")):
		get_tree().paused = true
	else:
		get_tree().paused = false
	UIPanelsProvider.close_panel("settings_ui")
