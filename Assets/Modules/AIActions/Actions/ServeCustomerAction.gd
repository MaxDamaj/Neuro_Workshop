extends NeuroAction
class_name ServeCustomerAction


func _get_name() -> String:
	return "serve customer"

func _get_description() -> String:
	return "Serve drink to customer"

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({})

func _validate_action(_data: IncomingData, _state: Dictionary) -> ExecutionResult:
	var validateResult : String = AIBartenderStrategy.validate_action(&"serve customer")
	if (validateResult != ""):
		return ExecutionResult.failure(validateResult)
	
	return ExecutionResult.success()

func _execute_action(_state: Dictionary) -> void:
	AIBartenderStrategy.execute_action(&"serve customer")
