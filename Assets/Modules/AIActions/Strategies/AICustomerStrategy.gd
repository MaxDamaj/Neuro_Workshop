extends Node
class_name AICustomerStrategy

static var _instance : AICustomerStrategy

@export var AiSpawner : NpcFixedView


func _ready() -> void:
	_instance = self
	
	if (AIConnectionStrategy.isOffline):
		var availableItemNames : Array = ItemsProvider.get_all_items_names()
		AiSpawner.on_order_finished.connect(func(context): generate_order(availableItemNames.pick_random(), randi_range(50, 200)))
		generate_order(availableItemNames.pick_random(), randi_range(50, 200))
	else:
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
	
	await _instance.get_tree().create_timer(0.55).timeout
	_instance.AiSpawner.start_task(task)

func _register_actions(context : String):
	if (context != ""): Context.send(context)
	var actionWindow := ActionWindow.new(self)
	
	actionWindow.set_force(0, "It's time for new order!", "", false)
	actionWindow.add_action(GenerateOrderAction.new(actionWindow))
	actionWindow.register()
