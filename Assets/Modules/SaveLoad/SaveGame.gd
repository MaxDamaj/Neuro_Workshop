extends Resource
class_name SaveGame

@export var AllStats : Dictionary

const SAVENAME_ARG = "--savename"
static var _savegamePath : String


func write_savegame() -> void:
	_check_savefile_name()
	ResourceSaver.save(self, _savegamePath)

static func load_savegame() -> Resource:
	_check_savefile_name()
	if (ResourceLoader.exists(_savegamePath)):
		return load(_savegamePath)
	return null


static func _check_savefile_name():
	if (_savegamePath != ""): return
	
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with(SAVENAME_ARG):
			var argValue = arg.split('=')[1]
			_savegamePath = "user://" + argValue
			return
	
	_savegamePath = "user://savegame.tres"
