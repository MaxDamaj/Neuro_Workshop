extends Node
class_name SaveDataProvider

static var path : NodePath = "/root/MainScene/_Providers/SaveDataProvider"

var saveData : SaveGame

func _ready():
	saveData = SaveGame.load_savegame()
	if (saveData == null):
		save_game()


func save_game():
	if (saveData == null):
		saveData = SaveGame.new()
	
	saveData.write_savegame()

func set_saved_value(key : String, value):
	saveData.AllStats[key] = value
	save_game()

func get_saved_value(key : String, default):
	if (!saveData.AllStats.has(key)):
		saveData.AllStats[key] = default
		save_game()
	return saveData.AllStats[key]
