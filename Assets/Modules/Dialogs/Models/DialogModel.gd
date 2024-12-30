class_name DialogModel

var speakers : Array[String]
var endMusic : String
var phrases : Array[DialogPhraseModel]

func _init(newSpeakers : Array[String], newPhrases : Array[DialogPhraseModel]) -> void:
	speakers = newSpeakers
	phrases = newPhrases
