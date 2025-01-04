extends NeuroAction
class_name CheckRecipeBookAction


func _get_name() -> String:
	return "check recipe book"

func _get_description() -> String:
	return "Don't know how to make the drink for current customer? Check recipe book!"

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({ })

func _validate_action(_data: IncomingData, _state: Dictionary) -> ExecutionResult:
	var validateResult : String = AIBartenderStrategy.validate_action(&"interact with Recipe book")
	if (validateResult != ""):
		return ExecutionResult.failure(validateResult)
	
	return ExecutionResult.success()

func _execute_action(_state: Dictionary) -> void:
	AIBartenderStrategy.execute_action(&"interact with Recipe book")
