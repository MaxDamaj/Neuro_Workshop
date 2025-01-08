extends CanvasLayer
class_name UIConnectPanel

@export var EnterUrlContainer : Control
@export var CloseButton : Button
@export var ConnectButton : Button
@export var OfflineButton : Button
@export var HostLineEdit : LineEdit

@export var WaitConnectionContainer : Control
@export var CloseWaitButton : Button

var _level_id : int

func _ready() -> void:
	CloseButton.button_down.connect(func(): UIPanelsProvider.close_panel("connect_ui"))
	ConnectButton.button_down.connect(_try_connect)
	OfflineButton.button_down.connect(func(): AIConnectionStrategy.play_offline(_level_id))
	CloseWaitButton.button_down.connect(_cancel_connection)
	HostLineEdit.text_changed.connect(_host_line_text_changed)
	
	EnterUrlContainer.visible = true
	WaitConnectionContainer.visible = false
	HostLineEdit.text = SaveDataProvider.get_saved_value("ws_url", "ws://127.0.0.1:8000")
	ConnectButton.disabled = HostLineEdit.text == ""

func _exit_tree() -> void:
	SaveDataProvider.set_saved_value("ws_url", HostLineEdit.text)

func init_args(args : Dictionary):
	if args.has("level_id"):
		_level_id = args["level_id"]


func _try_connect():
	AIConnectionStrategy.try_connect(HostLineEdit.text, _level_id)
	EnterUrlContainer.visible = false
	WaitConnectionContainer.visible = true

func _cancel_connection():
	AIConnectionStrategy.close_connection()
	EnterUrlContainer.visible = true
	WaitConnectionContainer.visible = false

func _host_line_text_changed(text : String):
	ConnectButton.disabled = text.length() == 0
