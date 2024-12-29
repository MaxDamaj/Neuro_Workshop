extends CanvasLayer
class_name UIWorkshopPanel

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var SettingsButton : Button
@export var CloseSettingsButton : Button
@export var MainMenuButton : Button
@export var SettingsContainer : Control

@export var Lifes : Array[TextureRect]
@export var CompletionLabel : Label

func _ready() -> void:
	SettingsContainer.visible = false
	SettingsButton.button_down.connect(_switch_settings_panel)
	CloseSettingsButton.button_down.connect(_switch_settings_panel)
	MainMenuButton.button_down.connect(_try_close_level)
	
	_levelTasksStrategy.on_task_completed.connect(_update_completion_value)
	_levelTasksStrategy.on_life_lost.connect(_update_lose_value)

func _switch_settings_panel():
	SettingsContainer.visible = !SettingsContainer.visible

func _try_close_level():
	_uiPanelsProvider.open_panel("exit_level_ui")

func _update_completion_value(progress : float):
	CompletionLabel.text = "Progress: " + str(roundi(progress * 100)) + "%"

func _update_lose_value(totalLifes : int, currentLifes : int):
	for i in range(Lifes.size()):
		if (totalLifes - currentLifes <= i + 1):
			Lifes[i].modulate = Color.RED
