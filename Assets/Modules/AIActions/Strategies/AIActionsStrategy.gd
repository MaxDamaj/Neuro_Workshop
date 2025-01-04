extends Node
class_name AIActionsStrategy


func _ready() -> void:
	if (AIConnectionStrategy.isOffline): return
	
	EventsProvider.subscribe_for_all(_send_context)
	AIBartenderStrategy.connect_on_action_finished(_register_actions)
	_register_actions()

func _exit_tree() -> void:
	if (AIConnectionStrategy.isOffline): return
	AIConnectionStrategy.close_connection()


func _send_context(eventName : StringName):
	Context.send(eventName, false)

func _register_actions():
	var actionWindow := ActionWindow.new(self)
	
	actionWindow.add_action(CheckRecipeBookAction.new(actionWindow))
	actionWindow.add_action(InteractWithTableAction.new(actionWindow))
	
	if (AIBartenderStrategy.validate_action(&"pick up vodka") == ""):
		actionWindow.add_action(PickUpItemAction.new(actionWindow))
	
	if (AIBartenderStrategy.validate_action(&"serve customer") == ""):
		actionWindow.add_action(ServeCustomerAction.new(actionWindow))
	
	actionWindow.register()
