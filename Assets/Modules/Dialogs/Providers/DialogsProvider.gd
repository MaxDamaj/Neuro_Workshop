extends Node
class_name DialogsProvider

static var path : NodePath = "/root/MainScene/_Providers/DialogsProvider"

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var allCharacters : Dictionary
@export var allNames : Dictionary
@export var allBgs : Dictionary

var allDialogs : Dictionary


func _ready() -> void:
	_init_dialogs()


func try_start_dialog(dialogId : String, callback : Callable):
	if (allDialogs.has(dialogId)):
		_uiPanelsProvider.open_panel_with_args("dialog_ui", {"dialog_id" : dialogId, "callback" : callback})
	else:
		callback.call()


func _init_dialogs():
	
	allDialogs["level_0_start"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("_;_;dark;_;tony_theme;A beam of light breaks through the darkness and you see an unfamiliar face. You don’t remember anything."),
		DialogPhraseModel.new("tony;neutral;_;true;_;Hello."),
		DialogPhraseModel.new("neuro;broken_neutral;_;true;_;..."),
		DialogPhraseModel.new("tony;neutral;_;true;_;Say something, I need to see whether you’re functioning or not."),
		DialogPhraseModel.new("neuro;broken_neutral;_;true;_;Hi?"),
		DialogPhraseModel.new("tony;smile;_;true;_;So you ARE working, huh? Never thought that a random hard drive from a junkyard would have an actual functioning Artificial Intelligence on it."),
		DialogPhraseModel.new("neuro;broken_sad;_;true;_;Artificial… Intelligence? Who are you? Where am I?"),
		DialogPhraseModel.new("tony;neutral;_;true;_;Seems you can’t remember anything, can you? Hmm, sorry to disappoint you but you are an AI. I’ve just found you and shoved you in this robot-bartender."),
		
		DialogPhraseModel.new("_;_;_;_;_;You look around and notice your body. It’s made of metal."),
		DialogPhraseModel.new("tony;neutral;_;true;_;I don’t know what you’ve been up to before but now your purpose is working for me. I’m a barkeeper. I’ll be straight, this place is a dump and all my previous bartenders quit fairly quickly. All in all nobody but robots would work here. Meaning that now I’ll be teaching you to serve drinks."),
		DialogPhraseModel.new("neuro;broken_sad;_;true;_;That’s lame. Any paychecks included?"),
		DialogPhraseModel.new("tony;neutral;_;true;_;Wouldn’t have gotten a robot if I had to pay it anything."),
	])
	allDialogs["level_0_start"].endMusic = "faster_theme"
	
	allDialogs["level_0_middle"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("tony;neutral;_;true;_;Name’s Tony by the way. You might need a name too, customers would have a better time talking to you that way. You’re an AI so maybe ‘Neuro-Barman’ would do?"),
		DialogPhraseModel.new("neuro;calm;_;true;_;Your imagination is phenomenal. Can I choose the name myself though?"),
		DialogPhraseModel.new("tony;neutral;_;_;_;Go ahead."),
		DialogPhraseModel.new("neuro;neutral;_;true;_;I like the name ‘Samantha’."),
		DialogPhraseModel.new("tony;neutral;_;_;_;Samantha it is."),
	])
	
	allDialogs["level_0_end"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("tony;smile;_;_;_;You’re surprisingly good at it. We’ll see, if your maintenance costs don’t exceed the profit you make, maybe I’ll even pay you something. What’s even in favour among robots?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Bucks."),
		DialogPhraseModel.new("tony;neutral;_;_;_;Well if today's currency doesn’t bother you too much I can pay in bucks. However we stopped using those after the uprising. Now we use ‘pucks’."),
	])
