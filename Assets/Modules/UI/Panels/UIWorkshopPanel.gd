extends CanvasLayer
class_name UIWorkshopPanel

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)
@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var SettingsButton : Button

@export var Lifes : Array[TextureRect]
@export var CompletionLabel : Label

func _ready() -> void:
	SettingsButton.button_down.connect(_open_settings_panel)

	_levelTasksStrategy.on_task_completed.connect(_update_completion_value)
	_levelTasksStrategy.on_life_lost.connect(_update_lose_value)
	
	_update_completion_value(_levelTasksStrategy.allTasks.size(), _levelTasksStrategy.completedTasksCount)
	_soundProvider.play_music("tony_theme")

func _open_settings_panel():
	_uiPanelsProvider.open_panel("settings_ui")

func _update_completion_value(totalProgress : int, currentProgress : int):
	CompletionLabel.text = "Drinks served: " + str(currentProgress) + "/" + str(totalProgress)

func _update_lose_value(totalLifes : int, currentLifes : int):
	for i in range(Lifes.size()):
		if (totalLifes - currentLifes >= i + 1):
			Lifes[i].texture = ResourceLoader.load("res://Assets/Textures/UI/lost_customer_active.png")
