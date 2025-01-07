extends Node
class_name UIPanelsProvider

static var _instance : UIPanelsProvider

@export var allPanels : Dictionary

signal on_panel_closed(panelName : String)

var _openedPanels : Dictionary


func _ready() -> void:
	_instance = self
	open_panel("main_ui")


static func open_panel(panelName : String):
	if (_instance == null): return
	if (_instance._openedPanels.has(panelName)): return
	
	var panel : PackedScene = _instance.allPanels[panelName]
	var panelObj = panel.instantiate()
	var root = _instance.get_node("/root/MainScene")
	root.add_child.call_deferred(panelObj)
	_instance._openedPanels[panelName] = panelObj

static func open_panel_with_args(panelName : String, args : Dictionary):
	if (_instance == null): return
	if (_instance._openedPanels.has(panelName)): return
	open_panel(panelName)
	
	if (_instance._openedPanels[panelName].has_method("init_args")):
		_instance._openedPanels[panelName].init_args(args)

static func close_panel(panelName : String):
	if (_instance._instance == null): return
	if (!_instance._openedPanels.has(panelName)): return
	
	_instance._openedPanels[panelName].queue_free()
	_instance._openedPanels.erase(panelName)
	_instance.on_panel_closed.emit(panelName)

static func is_panel_open(panelName : String) -> bool:
	if (_instance == null): return false
	return _instance._openedPanels.has(panelName)

static func connect_on_panel_closed(callback : Callable):
	_instance.on_panel_closed.connect(callback)

static func show_message(message : String, color : Color):
	close_panel("message_ui")
	
	var messageArgs := Dictionary()
	messageArgs["message"] = message
	messageArgs["color"] = color
	open_panel_with_args("message_ui", messageArgs)
