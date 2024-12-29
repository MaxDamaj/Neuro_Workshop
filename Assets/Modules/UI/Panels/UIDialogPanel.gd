extends Node
class_name UIDialogPanel

@export var NextStepButton : Button

var _dialogId : String


func _ready() -> void:
	NextStepButton.button_down.connect(_proceed_dialog)

func init_args(args : Dictionary):
	#При открытии панели будет передаваться айдишник диалога, по которому можно будет получить данные диалога из провайдера
	#Провайдера пока нет)
	if args.has("dialog_id"):
		_dialogId = args["dialog_id"]


func _proceed_dialog():
	#Тут писать реализацию показа следующих строк диалога
	pass
