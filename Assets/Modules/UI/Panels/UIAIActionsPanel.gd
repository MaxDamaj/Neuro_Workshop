extends CanvasLayer
class_name UIAIActionsPanel

@export var CallbacksLabel : Label
@export var ActionsContainer : Control
@export var ActionButton : PackedScene

const MAX_SAVED_EVENTS_COUNT : int = 8
var _allActions : Array
var _calledEvents : Array[String]
var _actionButtons : Array[Button]

func _ready() -> void:
	_allActions = AIBartenderStrategy.get_actions_list()
	CallbacksLabel.text = ""
	EventsProvider.subscribe_for_all(_on_event_called)
	AIBartenderStrategy.connect_on_action_started(_on_action_started)
	AIBartenderStrategy.connect_on_action_finished(_on_action_finished)
	
	for action : StringName in _allActions:
		var button : Button = ActionButton.instantiate()
		ActionsContainer.add_child(button)
		button.text = action
		button.button_down.connect(func(): AIBartenderStrategy.execute_action(action))
		button.disabled = AIBartenderStrategy.validate_action(action) != ""
		_actionButtons.append(button)


func _on_event_called(eventName : StringName):
	_calledEvents.append("> %s" % eventName)
	
	if (_calledEvents.size() > MAX_SAVED_EVENTS_COUNT):
		_calledEvents.remove_at(0)
	
	var callbackString := String()
	for line in _calledEvents:
		callbackString += "%s\n" % line
	
	CallbacksLabel.text = callbackString

func _on_action_started():
	for button in _actionButtons:
		button.disabled = true

func _on_action_finished():
	for i in range(_allActions.size()):
		_actionButtons[i].disabled = AIBartenderStrategy.validate_action(_allActions[i]) != ""
