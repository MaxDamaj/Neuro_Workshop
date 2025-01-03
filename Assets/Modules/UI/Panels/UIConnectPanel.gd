extends CanvasLayer
class_name UIConnectPanel

@export var CloseButton : Button
@export var ConnectButton : Button
@export var OfflineButton : Button


func _ready() -> void:
	CloseButton.button_down.connect(func(): UIPanelsProvider.close_panel("connect_ui"))
