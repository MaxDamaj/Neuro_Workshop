extends CanvasLayer
class_name UIAIActionsPanel

@export var CallbacksLabel : Label
@export var ActionsContainer : Control
@export var ActionButton : PackedScene

const MAX_SAVED_EVENTS_COUNT : int = 8
var _calledEvents : Array[String]

func _ready() -> void:
	var actions = AIBartenderStrategy.get_actions_list()
	CallbacksLabel.text = ""
	EventsProvider.subscribe_for_all(_on_event_called)
	
	for action : StringName in actions:
		var button : Button = ActionButton.instantiate()
		ActionsContainer.add_child(button)
		button.text = action
		button.button_down.connect(func(): AIBartenderStrategy.try_execute_action(action))


func _on_event_called(eventName : StringName):
	_calledEvents.append("> %s" % eventName)
	
	if (_calledEvents.size() > MAX_SAVED_EVENTS_COUNT):
		_calledEvents.remove_at(0)
	
	var callbackString := String()
	for line in _calledEvents:
		callbackString += "%s\n" % line
	
	CallbacksLabel.text = callbackString
