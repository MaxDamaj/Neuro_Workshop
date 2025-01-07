class_name DialogPhraseModel

var speaker : String
var mood : String
var bgImage : String
var isNameHidden : bool
var music : String
var text : String

var options : PackedStringArray
var actions : PackedStringArray

func _init(rawData : String) -> void:
	var splitData = rawData.split(";")
	
	if (splitData.size() == 2):
		match splitData[0]:
			"options":
				options = splitData[1].split(':')
				return
			"actions":
				actions = splitData[1].split(':')
				return
	
	speaker = splitData[0]
	mood = splitData[1]
	bgImage = splitData[2]
	isNameHidden = splitData[3] == "true"
	music = splitData[4]
	text = splitData[splitData.size() - 1]
