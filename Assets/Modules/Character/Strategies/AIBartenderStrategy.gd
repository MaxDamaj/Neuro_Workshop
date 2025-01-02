extends Node
class_name AIBartenderStrategy

static var _instance : AIBartenderStrategy

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)

@export var actionPositions : Dictionary
@export var levelObjects : Dictionary

var _currentAction : StringName
var _player : AICharacterView

func _ready() -> void:
	_instance = self
	_player = get_tree().get_nodes_in_group("Player")[0]
	_player.on_target_reached.connect(_on_player_reached_position)
	UIPanelsProvider.open_panel("ai_actions_ui")
	
	var cuttingDesk : DecorManualMachineView = get_node(levelObjects["CuttingDesk"])
	cuttingDesk.on_item_produced.connect(_on_manual_work_complete)
	var mixer : DecorManualMachineView = get_node(levelObjects["Mixer"])
	mixer.on_item_produced.connect(_on_manual_work_complete)

func _exit_tree() -> void:
	UIPanelsProvider.close_panel("ai_actions_ui")

static func get_actions_list() -> Array:
	return _instance.actionPositions.keys()

static func try_execute_action(action : StringName):
	if (_instance._currentAction != &""):
		EventsProvider.call_event(&"previous action is not completed. Please wait...")
		return
	
	match action:
		&"pick up vodka": _instance._try_pick_up_item(action)
		&"pick up gin": _instance._try_pick_up_item(action)
		&"pick up tonic": _instance._try_pick_up_item(action)
		&"pick up rum": _instance._try_pick_up_item(action)
		&"pick up banana": _instance._try_pick_up_item(action)
		&"pick up lemon": _instance._try_pick_up_item(action)
		&"pick up lime": _instance._try_pick_up_item(action)
		&"pick up tomato": _instance._try_pick_up_item(action)
		&"pick up ermge juice": _instance._try_pick_up_item(action)
		&"pick up apple juice": _instance._try_pick_up_item(action)
		&"interact with Safe": _instance._try_pick_up_item(action)
		
		&"interact with Table1": _instance._try_interact_with_table(action, "Table1")
		&"interact with Table2": _instance._try_interact_with_table(action, "Table2")
		&"interact with Table3": _instance._try_interact_with_table(action, "Table3")
		&"interact with Table4": _instance._try_interact_with_table(action, "Table4")
		&"interact with Trash can": _instance._try_interact_with_table(action, "Trash")
		&"interact with Recipe book": _instance._try_interact_with_book(action)
		&"serve customer": _instance._try_interact_with_table(action, "Customer")
		
		&"interact with Cutting desk": _instance._try_interact_with_manual_machine(action, "CuttingDesk")
		&"interact with Mixer": _instance._try_interact_with_manual_machine(action, "CuttingDesk")
		&"interact with Carbonizer": _instance._try_interact_with_automatic_machine(action, "Carbonizer")
		&"interact with Blender": _instance._try_interact_with_automatic_machine(action, "Blender")


func _on_player_reached_position():
	match _currentAction:
		&"pick up vodka": _add_item("vodka")
		&"pick up gin": _add_item("gin")
		&"pick up tonic": _add_item("tonic")
		&"pick up rum": _add_item("rum")
		&"pick up banana": _add_item("banana")
		&"pick up lemon": _add_item("lemon")
		&"pick up lime": _add_item("lime")
		&"pick up tomato": _add_item("tomato")
		&"pick up ermge juice": _add_item("ermge_juice")
		&"pick up apple juice": _add_item("apple_juice")
		&"interact with Safe": _add_item("lava_lamp")
		
		&"interact with Table1": _interact_with_table("Table1")
		&"interact with Table2": _interact_with_table("Table2")
		&"interact with Table3": _interact_with_table("Table3")
		&"interact with Table4": _interact_with_table("Table4")
		&"interact with Trash can": _interact_with_table("Trash")
		&"interact with Recipe book": _interact_with_book()
		&"serve customer": _interact_with_table("Customer")
		
		&"interact with Cutting desk": _interact_with_manual_machine("CuttingDesk")
		&"interact with Mixer": _interact_with_manual_machine("Mixer")
		&"interact with Carbonizer": _interact_with_automatic_machine("Carbonizer")
		&"interact with Blender": _interact_with_automatic_machine("Blender")


static func finish_action():
	_instance._currentAction = &""

func _move_to_action_point(actionName : StringName):
	var node : Node2D = get_node(actionPositions[actionName])
	_player.moveAtPos = node.global_position
	_player.navAgent.target_position = _player.moveAtPos

func _on_manual_work_complete(machine : DecorManualMachineView):
	machine.aiProcessing = false
	finish_action()


#Items
func _try_pick_up_item(actionName : StringName):
	if (_player.itemName != ""):
		EventsProvider.call_event(&"you already have something in your hands")
		return
	
	_currentAction = actionName
	_move_to_action_point(actionName)

func _add_item(itemName : String):
	_player.add_item(itemName)
	finish_action()


#Tables
func _try_interact_with_table(actionName : StringName, tableName : String):
	var table : DecorTableView = get_node(levelObjects[tableName])
	if (_player.itemName == "" && table.ItemName == ""):
		EventsProvider.call_event(&"your hands is empty and the table is empty too")
		return
	
	_currentAction = actionName
	_move_to_action_point(actionName)

func _interact_with_table(tableName : String):
	var table : DecorTableView = get_node(levelObjects[tableName])
	table._try_interact_with_item()
	finish_action()


#Manual machines
func _try_interact_with_manual_machine(actionName : StringName, tableName : String):
	var table : DecorManualMachineView = get_node(levelObjects[tableName])
	if (_player.itemName == ""):
		EventsProvider.call_event(&"your hands is empty")
		return
	if (_player.itemName != "" && table.itemName != ""):
		EventsProvider.call_event(&"you already have something in your hands and table is occupied too")
		return
	
	_currentAction = actionName
	_move_to_action_point(actionName)
	

func _interact_with_manual_machine(tableName : String):
	var table : DecorManualMachineView = get_node(levelObjects[tableName])
	if (table._try_interact_with_item()):
		table.aiProcessing = true
	else:
		finish_action()


#Automatic machines
func _try_interact_with_automatic_machine(actionName : StringName, tableName : String):
	var table : DecorAutomaticMachineView = get_node(levelObjects[tableName])
	if (_player.itemName == "" && table.itemName == ""):
		EventsProvider.call_event(&"your hands is empty and table is empty too")
		return
	if (_player.itemName != "" && table.itemName != ""):
		EventsProvider.call_event(&"you already have something in your hands and table is occupied too")
		return
	
	_currentAction = actionName
	_move_to_action_point(actionName)

func _interact_with_automatic_machine(tableName : String):
	var table : DecorAutomaticMachineView = get_node(levelObjects[tableName])
	table._try_interact_with_item()
	finish_action()


#Book
func _try_interact_with_book(actionName : StringName):
	_currentAction = actionName
	_move_to_action_point(actionName)

func _interact_with_book():
	var item : ItemModel = _levelTasksStrategy.lastStartedTask.get_item()
	EventsProvider.call_event("%s: %s" % [item.name, item.recipe])
	finish_action()
