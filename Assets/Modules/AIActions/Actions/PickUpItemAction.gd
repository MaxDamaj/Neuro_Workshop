extends NeuroAction
class_name PickUpItemAction

var availableItemNames := ["vodka", "gin", "tonic", "rum",
	"banana", "lemon", "lime", "tomato",
	"ermge juice", "apple juice"
]


func _get_name() -> String:
	return "pick up item"

func _get_description() -> String:
	return "You can try to pick up item from storage, if your hands are empty"

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({
		"item": {
			"enum": ["vodka", "gin", "tonic", "rum", "banana", "lemon", "lime", "tomato", "ermge juice", "apple juice"]
		}
	})

func _validate_action(data: IncomingData, state: Dictionary) -> ExecutionResult:
	var item : String = data.get_string("item") # If Neuro makes this parameter null, this will return an empty string instead.
	if (item == ""):
		return ExecutionResult.failure("Action failed. Missing required parameter 'item'.")

	if (!availableItemNames.has(item)):
		return ExecutionResult.failure("Action failed. Invalid parameter 'item'.")
	
	var validateResult : String = AIBartenderStrategy.validate_action("pick up %s" % item)
	if (validateResult != ""):
		return ExecutionResult.failure(validateResult)
	
	state["itemName"] = item
	return ExecutionResult.success()

func _execute_action(state: Dictionary) -> void:
	AIBartenderStrategy.execute_action("pick up %s" % state["itemName"])
