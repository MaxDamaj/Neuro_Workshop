extends CanvasLayer
class_name UIConnectPanel

@export var EnterUrlContainer : Control
@export var CloseButton : Button
@export var ConnectButton : Button
@export var OfflineButton : Button
@export var HostLineEdit : LineEdit

@export var WaitConnectionContainer : Control
@export var CloseWaitButton : Button


func _ready() -> void:
	CloseButton.button_down.connect(func(): UIPanelsProvider.close_panel("connect_ui"))
	ConnectButton.button_down.connect(_try_connect)
	OfflineButton.button_down.connect(AIConnectionStrategy.play_offline)
	CloseWaitButton.button_down.connect(_cancel_connection)
	HostLineEdit.text_changed.connect(_host_line_text_changed)
	
	EnterUrlContainer.visible = true
	WaitConnectionContainer.visible = false
	ConnectButton.disabled = true


func _try_connect():
	AIConnectionStrategy.try_connect(HostLineEdit.text)
	EnterUrlContainer.visible = false
	WaitConnectionContainer.visible = true

func _cancel_connection():
	AIConnectionStrategy.close_connection()
	EnterUrlContainer.visible = true
	WaitConnectionContainer.visible = false

func _host_line_text_changed(text : String):
	ConnectButton.disabled = text.length() == 0
