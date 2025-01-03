extends Node
class_name AIActionsStrategy


func _ready() -> void:
	EventsProvider.subscribe_for_all(_send_context)
	
	var actionWindow := ActionWindow.new(self)
	actionWindow.add_action(PickUpItemAction.new(actionWindow))
	actionWindow.register()

func _send_context(eventName : StringName):
	Context.send(eventName, false)
