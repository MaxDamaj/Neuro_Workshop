extends Node
class_name AICustomerStrategy

static var _instance : AICustomerStrategy

@export var AiSpawner : NpcFixedView


func _ready() -> void:
	_instance = self
	
	if (AIConnectionStrategy.isOffline): return
	AiSpawner.on_order_finished.connect(_register_actions)
	_register_actions("Welcome to Abandoned bar! You play as Kayori and the task is to order the most complex drinks possible for the bartender.")

func _exit_tree() -> void:
	if (AIConnectionStrategy.isOffline): return
	AIConnectionStrategy.close_connection()


static func generate_order(item : String, time : float):
	var task = TaskModel.new()
	task.npcName = "evil"
	task.item = item
	task.waitingTime = time
	task.rarity = 1
	
	_instance.AiSpawner.start_task(task)

func _register_actions(context : String):
	if (context != ""): Context.send(context)
	var actionWindow := ActionWindow.new(self)
	
	actionWindow.set_force(0, "It's time for new order!", "", false)
	actionWindow.add_action(GenerateOrderAction.new(actionWindow))
	actionWindow.register()
