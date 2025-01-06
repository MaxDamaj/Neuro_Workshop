extends CanvasLayer
class_name UIWorkshopPanel

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)
@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

@export var SettingsButton : Button

@export var Lifes : Array[TextureRect]
@export var CompletionLabel : Label

func _ready() -> void:
	SettingsButton.button_down.connect(_open_settings_panel)

	_levelTasksStrategy.on_task_status_updated.connect(_update_completion_value)
	_levelTasksStrategy.on_life_lost.connect(_update_lose_value)
	
	_update_completion_value(_levelTasksStrategy.get_tasks_text())
	_soundProvider.play_music("tony_theme")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel")):
		if (UIPanelsProvider.is_panel_open("exit_level_ui")): return
		if (!UIPanelsProvider.is_panel_open("settings_ui")):
			UIPanelsProvider.open_panel("settings_ui")
		else:
			get_tree().paused = UISettingsPanel.wasPaused
			UIPanelsProvider.close_panel("settings_ui")


func _open_settings_panel():
	UIPanelsProvider.open_panel("settings_ui")

func _update_completion_value(text : String):
	CompletionLabel.text = text

func _update_lose_value(totalLifes : int, currentLifes : int):
	for i in range(Lifes.size()):
		if (totalLifes - currentLifes >= i + 1):
			Lifes[i].texture = ResourceLoader.load("res://Assets/Textures/UI/lost_customer_active.png")
