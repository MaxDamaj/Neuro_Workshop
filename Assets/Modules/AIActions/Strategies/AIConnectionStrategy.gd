extends Node
class_name AIConnectionStrategy

static var _instance : AIConnectionStrategy

@onready var _levelLoadStartegy : LevelLoadStrategy = get_node(LevelLoadStrategy.path)

@export var sdkScene : PackedScene

static var isOffline : bool = true
var _websocket : Websocket


func _ready() -> void:
	_instance = self


static func try_connect(url : String):
	if (_instance._websocket == null):
		_instance._websocket = _instance.sdkScene.instantiate()
		_instance.get_node("/root").add_child(_instance._websocket)
		_instance._websocket.on_connection_start.connect(_instance._connection_start)
	
	_instance._websocket.ws_start(url)

static func play_offline():
	isOffline = true
	UIPanelsProvider.close_panel("connect_ui")
	_instance._levelLoadStartegy.load_level(-2)

static func close_connection():
	isOffline = true
	_instance._websocket.ws_close()
	_instance._websocket.queue_free()


func _connection_start():
	isOffline = false
	UIPanelsProvider.close_panel("connect_ui")
	_levelLoadStartegy.load_level(-2)
