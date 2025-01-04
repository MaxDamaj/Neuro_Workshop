extends Node
class_name AIBartenderStrategy

static var _instance : AIBartenderStrategy

@onready var _levelTasksStrategy : LevelTasksStrategy = get_node(LevelTasksStrategy.path)

@export var actionPositions : Dictionary
@export var levelObjects : Dictionary

signal on_action_started
signal on_action_finished

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

static func validate_action(action : StringName) -> String:
	if (_instance._currentAction != &""):
		return "previous action is not completed. Please wait..."
	
	match action:
		&"pick up vodka": return _instance._validate_pick_up_item()
		&"pick up gin": return _instance._validate_pick_up_item()
		&"pick up tonic": return _instance._validate_pick_up_item()
		&"pick up rum": return _instance._validate_pick_up_item()
		&"pick up banana": return _instance._validate_pick_up_item()
		&"pick up lemon": return _instance._validate_pick_up_item()
		&"pick up lime": return _instance._validate_pick_up_item()
		&"pick up tomato": return _instance._validate_pick_up_item()
		&"pick up ermge juice": return _instance._validate_pick_up_item()
		&"pick up apple juice": return _instance._validate_pick_up_item()
		&"interact with Safe": return _instance._validate_pick_up_item()
		
		&"interact with Table1": return _instance._validate_interact_with_table("Table1")
		&"interact with Table2": return _instance._validate_interact_with_table("Table2")
		&"interact with Table3": return _instance._validate_interact_with_table("Table3")
		&"interact with Table4": return _instance._validate_interact_with_table("Table4")
		&"interact with Trash can": return _instance._validate_interact_with_table("Trash")
		&"serve customer": return _instance._validate_interact_with_table("Customer")
		
		&"interact with Recipe book": return ""
		
		&"interact with Cutting desk": return _instance._validate_interact_with_manual_machine("CuttingDesk")
		&"interact with Mixer": return _instance._validate_interact_with_manual_machine("CuttingDesk")
		&"interact with Carbonizer": return _instance._validate_interact_with_automatic_machine("Carbonizer")
		&"interact with Blender": return _instance._validate_interact_with_automatic_machine("Blender")
	
	return ""

static func execute_action(action : StringName):
	_instance._currentAction = action
	_instance._move_to_action_point(action)
	_instance.on_action_started.emit()

static func connect_on_action_started(callback : Callable):
	_instance.on_action_started.connect(callback)

static func connect_on_action_finished(callback : Callable):
	_instance.on_action_finished.connect(callback)


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


func _finish_action():
	_currentAction = &""
	on_action_finished.emit()

func _move_to_action_point(actionName : StringName):
	var node : Node2D = get_node(actionPositions[actionName])
	_player.moveAtPos = node.global_position
	_player.navAgent.target_position = _player.moveAtPos

func _on_manual_work_complete(machine : DecorManualMachineView):
	machine.aiProcessing = false
	_finish_action()

#Items
func _validate_pick_up_item() -> String:
	if (_player.itemName != ""):
		return "you already have something in your hands"
	
	return ""

func _add_item(itemName : String):
	_player.add_item(itemName)
	_finish_action()


#Tables
func _validate_interact_with_table(tableName : String) -> String:
	var table : DecorTableView = get_node(levelObjects[tableName])
	if (_player.itemName == "" && table.ItemName == ""):
		return "your hands is empty and the table is empty too"
	
	return ""

func _interact_with_table(tableName : String):
	var table : DecorTableView = get_node(levelObjects[tableName])
	table._try_interact_with_item()
	_finish_action()


#Manual machines
func _validate_interact_with_manual_machine(tableName : String) -> String:
	var table : DecorManualMachineView = get_node(levelObjects[tableName])
	if (_player.itemName == ""):
		return "your hands is empty"
	if (_player.itemName != "" && table.itemName != ""):
		return "you already have something in your hands and table is occupied too"
	
	return ""

func _interact_with_manual_machine(tableName : String):
	var table : DecorManualMachineView = get_node(levelObjects[tableName])
	if (table._try_interact_with_item()):
		table.aiProcessing = true
	else:
		_finish_action()


#Automatic machines
func _validate_interact_with_automatic_machine(tableName : String) -> String:
	var table : DecorAutomaticMachineView = get_node(levelObjects[tableName])
	if (_player.itemName == "" && table.itemName == ""):
		return "your hands is empty and table is empty too"
	if (_player.itemName != "" && table.itemName != ""):
		return "you already have something in your hands and table is occupied too"
	
	return ""

func _interact_with_automatic_machine(tableName : String):
	var table : DecorAutomaticMachineView = get_node(levelObjects[tableName])
	table._try_interact_with_item()
	_finish_action()


#Book
func _interact_with_book():
	var item : ItemModel = _levelTasksStrategy.lastStartedTask.get_item()
	EventsProvider.call_event("%s: %s" % [item.name, item.recipe])
	_finish_action()
