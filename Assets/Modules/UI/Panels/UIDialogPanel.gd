extends CanvasLayer
class_name UIDialogPanel

@onready var _dialogsProvider : DialogsProvider = get_node(DialogsProvider.path)
@onready var _soundProvider : SoundProvider = get_node(SoundProvider.path)

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

@export var Options : OptionsView 

var SPEAKER_LEFT_HIDDEN_X = -1064
var SPEAKER_LEFT_SHOWN_X = -64
var SPEAKER_RIGHT_HIDDEN_X = 3000
var SPEAKER_RIGHT_SHOWN_X = 1984

var _callback : Callable
var _dialogId : String
var _dialog : DialogModel
var _currentStep : int = -1

var _speakersID := Dictionary()
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
	Options.on_option_selected.connect(_switch_to_dialog)
	UIPanelsProvider.connect_on_panel_closed(_proceed_check)
	_dialog = _dialogsProvider.allDialogs[_dialogId]
	
	for i in range(_dialog.speakers.size()):
		_speakersTextures[_dialog.speakers[i]] = Speakers[i]
		_loadedTextures[_dialog.speakers[i]] = ""
		_speakersID[_dialog.speakers[i]] = i
	
	#Speakers[0].position = Vector2(SPEAKER_LEFT_HIDDEN_X, Speakers[0].position.y)
	#Speakers[1].position = Vector2(SPEAKER_RIGHT_HIDDEN_X, Speakers[1].position.y)
	
	Root.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	var target_color = Color.WHITE
	tween.tween_property(Root, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		Root.modulate = target_color
	)
	
	NextStepButton.disabled = true
	_proceed_dialog()
	await get_tree().create_timer(1.25).timeout
	NextStepButton.disabled = false

func init_args(args : Dictionary):
	if args.has("dialog_id"):
		_dialogId = args["dialog_id"]
	if args.has("callback"):
		_callback = args["callback"]

func _switch_to_dialog(dialogId : String):
	_dialogId = dialogId
	_dialog = _dialogsProvider.allDialogs[_dialogId]
	_currentStep = -1
	_proceed_dialog()

func _show_sprite(index:int)->void:
	var tween = create_tween()
	var target_pos : Vector2
	if (index==0):
		target_pos = Vector2(SPEAKER_LEFT_SHOWN_X, Speakers[index].position.y)
	elif (index==1):
		target_pos = Vector2(SPEAKER_RIGHT_SHOWN_X, Speakers[index].position.y)
	else:
		return
	tween.tween_property(Speakers[index], "position", target_pos, 0.5)
	tween.tween_callback(
	func():
		Speakers[index].position = target_pos
	)	

func _proceed_dialog():
	if (Options.isBusy): return
	_currentStep += 1
	
	if (_currentStep >= _dialog.phrases.size()):
		_close_panel()
		return
	
	var phrase : DialogPhraseModel = _dialog.phrases[_currentStep]
	
	if (phrase.options.size() > 0):
		Options.show_phrase(phrase)
		return
	if (phrase.actions.size() > 0):
		_proceed_actions(phrase)
		return
	
	SpeakerNameLabel.get_parent().visible = phrase.speaker != "_"
	SpeakerNameLabel.text = "???" if phrase.isNameHidden else _dialogsProvider.allNames[phrase.speaker]
	
	if (phrase.music != "_"): _soundProvider.play_music(phrase.music)
	
	for speakerId in _speakersTextures:
		if (speakerId == phrase.speaker):
			_speakersTextures[speakerId].modulate = Color.WHITE
			_speakersTextures[speakerId].z_index = 1
			var charMood : String = phrase.speaker + "_" + phrase.mood
			if (_loadedTextures[speakerId] != charMood):
				#if(_loadedTextures[speakerId] == ""):
				#	_show_sprite(_speakersID[speakerId])
				_speakersTextures[speakerId].texture = _dialogsProvider.allCharacters[phrase.speaker][phrase.mood]
				_loadedTextures[speakerId] = phrase.speaker + "_" + phrase.mood
		else:
			_speakersTextures[speakerId].modulate = Color.DIM_GRAY
			_speakersTextures[speakerId].z_index = 0
	
	for speaker : TextureRect in Speakers:
		speaker.visible = phrase.bgImage == "_"
	
	DialogPicture.texture = null if phrase.bgImage == "_" else _dialogsProvider.allBgs[phrase.bgImage]
	DialogLabel.text = phrase.text

func _proceed_actions(phrase : DialogPhraseModel):
	for action in phrase.actions:
		var split = action.split("|")
		match split[0]:
			"open_panel":
				UIPanelsProvider.open_panel(split[1])
			"open_panel_with_args":
				var argsSplit = split[1].split(',')
				var args := Dictionary()
				for argPack : String in argsSplit:
					var fields = argPack.split("=")
					if (fields.size() > 1):
						args[fields[0]] = fields[1]
				UIPanelsProvider.open_panel_with_args(argsSplit[0], args)

func _proceed_check(panelName : String):
	if (panelName == "picture_ui"):
		_proceed_dialog()

func _close_panel():
	var tween = create_tween()
	var target_color = Color(1, 1, 1, 0)
	tween.tween_property(Root, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		get_tree().paused = false
		if (_dialog.endMusic != ""): _soundProvider.play_music(_dialog.endMusic)
		if(_callback != null): _callback.call()
		UIPanelsProvider.close_panel("dialog_ui")
	)

func _open_settings_panel():
	UIPanelsProvider.open_panel("settings_ui")

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
