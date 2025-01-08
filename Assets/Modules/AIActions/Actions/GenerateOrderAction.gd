extends NeuroAction
class_name GenerateOrderAction

var availableItemNames : PackedStringArray
var availableTimeIntervals := ["50", "60", "75", "90", "120", "150", "200"]


func _init(action_window: ActionWindow) -> void:
	super._init(action_window)
	availableItemNames = ItemsProvider.get_all_items_names()

func _get_name() -> String:
	return "generate order"

func _get_description() -> String:
	return "Use your imagination and try to create fancy order for player"

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({
		"item": {
			"enum": availableItemNames
		},
		"time": {
			"enum": availableTimeIntervals
		}
	})

func _validate_action(data: IncomingData, state: Dictionary) -> ExecutionResult:
	var item : String = data.get_string("item") # If Neuro makes this parameter null, this will return an empty string instead.
	if (item == ""):
		return ExecutionResult.failure("Action failed. Missing required parameter 'item'.")
	if (!availableItemNames.has(item)):
		return ExecutionResult.failure("Action failed. Invalid parameter 'item'.")
	
	var time : String = data.get_string("time")
	if (time == ""):
		return ExecutionResult.failure("Action failed. Missing required parameter 'time'.")
	if (!availableTimeIntervals.has(time)):
		return ExecutionResult.failure("Action failed. Invalid parameter 'time'.")
	
	state["item"] = item
	state["time"] = time.to_float()
	return ExecutionResult.success()

func _execute_action(state: Dictionary) -> void:
	AICustomerStrategy.generate_order(state["item"], state["time"])
