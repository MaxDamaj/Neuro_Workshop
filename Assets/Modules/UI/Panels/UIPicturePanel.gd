extends CanvasLayer
class_name UIPicturePanel

@onready var _dialogsProvider : DialogsProvider = get_node(DialogsProvider.path)

@export var Root : Control
@export var TitleLabel : Label
@export var Picture : TextureRect
@export var NextButton : Button

var _pictureId : String
var _titleText : String


func _ready() -> void:
	Root.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	var target_color = Color.WHITE
	tween.tween_property(Root, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		Root.modulate = target_color
	)
	
	Picture.texture = _dialogsProvider.allBgs[_pictureId]
	TitleLabel.text = _titleText
	NextButton.button_down.connect(_close_panel)

func init_args(args : Dictionary):
	if args.has("picture_id"):
		_pictureId = args["picture_id"]
	if args.has("title_text"):
		_titleText = args["title_text"]


func _close_panel():
	var tween = create_tween()
	var target_color = Color(1, 1, 1, 0)
	tween.tween_property(Root, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		UIPanelsProvider.close_panel("picture_ui")
	)
