extends Node
class_name UIPanelsProvider

static var path : NodePath = "/root/MainScene/_Providers/UIPanelsProvider"

@export var allPanels : Dictionary

var _openedPanels : Dictionary


func _ready() -> void:
	open_panel("main_ui")


func open_panel(panelName : String):
	if (_openedPanels.has(panelName)): return
	
	var panel : PackedScene = allPanels[panelName]
	var panelObj = panel.instantiate()
	var root = get_node("/root/MainScene")
	root.add_child.call_deferred(panelObj)
	_openedPanels[panelName] = panelObj

func open_panel_with_args(panelName : String, args : Dictionary):
	if (_openedPanels.has(panelName)): return
	open_panel(panelName)
	
	if (_openedPanels[panelName].has_method("init_args")):
		_openedPanels[panelName].init_args(args)

func close_panel(panelName : String):
	if (!_openedPanels.has(panelName)): return
	
	_openedPanels[panelName].queue_free()
	_openedPanels.erase(panelName)

func is_panel_open(panelName : String) -> bool:
	return _openedPanels.has(panelName)


func show_message(message : String, color : Color):
	close_panel("message_ui")
	
	var messageArgs := Dictionary()
	messageArgs["message"] = message
	messageArgs["color"] = color
	open_panel_with_args("message_ui", messageArgs)
