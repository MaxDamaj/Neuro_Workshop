extends Node
class_name SaveDataProvider

static var _instance : SaveDataProvider

var saveData : SaveGame

func _ready():
	_instance = self
	saveData = SaveGame.load_savegame()
	if (saveData == null):
		_save_game()

func _save_game():
	if (saveData == null):
		saveData = SaveGame.new()
	
	saveData.write_savegame()


static func set_saved_value(key : String, value):
	_instance.saveData.AllStats[key] = value
	_instance._save_game()

static func get_saved_value(key : String, default):
	if (!_instance.saveData.AllStats.has(key)):
		_instance.saveData.AllStats[key] = default
		_instance._save_game()
	return _instance.saveData.AllStats[key]
