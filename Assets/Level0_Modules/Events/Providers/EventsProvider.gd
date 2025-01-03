extends Node
class_name EventsProvider

static var _instance : EventsProvider

signal on_event_called(eventName : StringName)


func _ready() -> void:
	_instance = self


static func call_event(eventName):
	if (_instance == null): return
	_instance.on_event_called.emit(eventName)

static func subscribe(eventName : StringName, callback : Callable):
	if (_instance == null): return
	
	var end_func : Callable = func(event : StringName):
		if (event != eventName): return
		callback.call()
	
	_instance.on_event_called.connect(end_func)

static func subscribe_for_all(callback : Callable):
	if (_instance == null): return
	_instance.on_event_called.connect(callback)
