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
		SaveDataProvider.set_saved_value("music_volume", value)
		musicTrack.volume_db = dbCurve.sample(value)
		musicVolume = value
	get:
		return musicVolume
	
var soundVolume : float:
	set(value):
		SaveDataProvider.set_saved_value("sound_volume", value)
		soundTrack.volume_db = dbCurve.sample(value)
		soundVolume = value
	get:
		return soundVolume

var _playedMusic : String


func _ready() -> void:
	musicVolume = SaveDataProvider.get_saved_value("music_volume", 0.3)
	soundVolume = SaveDataProvider.get_saved_value("sound_volume", 0.6)
	musicTrack.finished.connect(_play_track_again)


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

func _play_track_again():
	if (musicTrack.stream == null): return
	musicTrack.play()
