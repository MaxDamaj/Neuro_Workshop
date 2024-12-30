extends CanvasLayer
class_name UIDialogPanel

@onready var _dialogsProvider : DialogsProvider = get_node(DialogsProvider.path)
@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var Root : Control
@export var SkipButton : Button
@export var SettingsButton :Button
@export var NextStepButton : Button
@export var HideButton : Button
@export var ShowButton : Button
@export var DialogPicture : TextureRect
@export var Speakers : Array[TextureRect]
@export var SpeakerNameLabel : Label
@export var DialogLabel : Label
@export var DialogueLine : Panel

var _callback : Callable
var _dialogId : String
var _dialog : DialogModel
var _currentStep : int = -1

var _speakersTextures := Dictionary()
var _loadedTextures := Dictionary()

func _ready() -> void:
	get_tree().paused = true
	
	ShowButton.visible = false
	
	NextStepButton.button_down.connect(_proceed_dialog)
	SkipButton.button_down.connect(_close_panel)
	SettingsButton.button_down.connect(_open_settings_panel)
	HideButton.button_down.connect(_hide_dialogue)
	ShowButton.button_down.connect(_show_dialogue)
	_dialog = _dialogsProvider.allDialogs[_dialogId]
	
	for i in range(_dialog.speakers.size()):
		_speakersTextures[_dialog.speakers[i]] = Speakers[i]
		_loadedTextures[_dialog.speakers[i]] = ""
	
	Root.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	var target_color = Color.WHITE
	tween.tween_property(Root, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		Root.modulate = target_color
	)
	
	_proceed_dialog()

func init_args(args : Dictionary):
	if args.has("dialog_id"):
		_dialogId = args["dialog_id"]
	if args.has("callback"):
		_callback = args["callback"]


func _proceed_dialog():
	_currentStep += 1
	
	if (_currentStep >= _dialog.phrases.size()):
		_close_panel()
		return
	
	var phrase : DialogPhraseModel = _dialog.phrases[_currentStep]
	SpeakerNameLabel.get_parent().visible = phrase.speaker != "_"
	SpeakerNameLabel.text = "???" if phrase.isNameHidden else _dialogsProvider.allNames[phrase.speaker]
	
	for speakerId in _speakersTextures:
		if (speakerId == phrase.speaker):
			_speakersTextures[speakerId].modulate = Color.WHITE
			var charMood : String = phrase.speaker + "_" + phrase.mood
			if (_loadedTextures[speakerId] != charMood):
				_speakersTextures[speakerId].texture = _dialogsProvider.allCharacters[phrase.speaker][phrase.mood]
				_loadedTextures[speakerId] = phrase.speaker + "_" + phrase.mood
		else:
			_speakersTextures[speakerId].modulate = Color.DIM_GRAY
	
	DialogPicture.texture = null if phrase.bgImage == "_" else _dialogsProvider.allBgs[phrase.bgImage]
	DialogLabel.text = phrase.text

func _close_panel():
	var tween = create_tween()
	var target_color = Color(1, 1, 1, 0)
	tween.tween_property(Root, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		get_tree().paused = false
		if(_callback != null): _callback.call()
		_uiPanelsProvider.close_panel("dialog_ui")
	)
	
func _open_settings_panel():
	_uiPanelsProvider.open_panel("settings_ui")
	
func _hide_dialogue():
	HideButton.visible = false
	ShowButton.visible = true
	DialogueLine.visible = false
	NextStepButton.disabled = true
	
func _show_dialogue():
	ShowButton.visible = false
	HideButton.visible = true
	DialogueLine.visible = true
	NextStepButton.disabled = false
