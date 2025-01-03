extends NeuroAction
class_name PickUpItemAction

var availableItemNames := ["vodka", "gin", "tonic", "rum",
	"banana", "lemon", "lime", "tomato",
	"ermge juice", "apple juice"
]

# This action will always be part of an action window, so we pass that as a parameter
func _init(window: ActionWindow) -> void:
	super(window)

func _get_name() -> String:
	return "pick up item"

func _get_description() -> String:
	return "Decide if the defendant is innocent or guilty."

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({
		"item": {
			"enum": ["vodka", "guilty"]
		}
	})

func _validate_action(data: IncomingData, state: Dictionary) -> ExecutionResult:
	var item : String = data.get_string("item") # If Neuro makes this parameter null, this will return an empty string instead.
	if (item == ""):
		return ExecutionResult.failure("Action failed. Missing required parameter 'item'.")

	if (availableItemNames.has(item)):
		state["itemName"] = item
		return ExecutionResult.success()
	else:
		return ExecutionResult.failure("Action failed. Invalid parameter 'item'.")

func _execute_action(state: Dictionary) -> void:
	AIBartenderStrategy.try_execute_action("pick up %s" % state["itemName"])
