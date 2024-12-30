extends Node
class_name SoundProvider

static var path : NodePath = "/root/MainScene/_Providers/SoundProvider"

@export var dbCurve : Curve
@export var allMusics : Dictionary
@export var allSounds : Dictionary

@export var musicTrack : AudioStreamPlayer
@export var soundTrack : AudioStreamPlayer

var musicVolume : float:
	set(value):
		musicTrack.volume_db = dbCurve.sample(value)
		musicVolume = value
	get:
		return musicVolume
	
var soundVolume : float:
	set(value):
		soundTrack.volume_db = dbCurve.sample(value)
		soundVolume = value
	get:
		return soundVolume

var _playedMusic : String


func _ready() -> void:
	musicVolume = 0.3
	soundVolume = 0.6


func play_music(musicId : String):
	if (_playedMusic == musicId): return
	
	if (allMusics.has(musicId)):
		musicTrack.stream = allMusics[musicId]
		musicTrack.play()
		_playedMusic = musicId

func play_sound(soundId : String):
	if (!allSounds.has(soundId)): return
	
	soundTrack.stream = allSounds[soundId].pick_random()
	soundTrack.play()
