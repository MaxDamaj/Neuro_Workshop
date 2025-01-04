extends NeuroAction
class_name InteractWithTableAction

var availableItemNames := ["Table1", "Table2", "Table3", "Table4",
	"Trash can", "Cutting desk", "Mixer", "Carbonizer", "Blender"
]


func _get_name() -> String:
	return "interact with table"

func _get_description() -> String:
	return "Place, combine, mix, blend and other stuff you can do on the kitchen"

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({
		"table": {
			"enum": ["Table1", "Table2", "Table3", "Table4", "Trash can", "Cutting desk", "Mixer", "Carbonizer", "Blender"]
		}
	})

func _validate_action(data: IncomingData, state: Dictionary) -> ExecutionResult:
	var table : String = data.get_string("table") # If Neuro makes this parameter null, this will return an empty string instead.
	if (table == ""):
		return ExecutionResult.failure("Action failed. Missing required parameter 'item'.")

	if (!availableItemNames.has(table)):
		return ExecutionResult.failure("Action failed. Invalid parameter 'table'.")
	
	var validateResult : String = AIBartenderStrategy.validate_action("interact with %s" % table)
	if (validateResult != ""):
		return ExecutionResult.failure(validateResult)
	
	state["tableName"] = table
	return ExecutionResult.success()

func _execute_action(state: Dictionary) -> void:
	AIBartenderStrategy.execute_action("interact with %s" % state["tableName"])
