class_name AudioManager extends Node

static var AUDIO_MANAGER_INSTANCE: AudioManager
var _sounds = {}

enum AudioType {
	PERSISTENT,
	TEMPORARY
}

static var COMMON_SOUND_PATHS: Dictionary[String, String] = {
	BKG_PATH = "res://Scenes/Levels/Test/mfcc-gaming-game-video-game-music-522352.mp3",
	JUMP_SOUND_EFFECT = "res://Scenes/Levels/Test/maro-jump-sound-effect_1.mp3"
}

func _init() -> void:
	assert(AUDIO_MANAGER_INSTANCE == null, "AudioManager class is singleton. Use the static var `AUDIO_MANAGER_INSTANCE` instead of using AudioStreamManager.new().")
	AUDIO_MANAGER_INSTANCE = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("AudioManager._ready")
	
	# Example with background music playing on start
	play_sound(AudioType.PERSISTENT, COMMON_SOUND_PATHS.BKG_PATH)


func _process(_delta: float) -> void:
	for sound_path in _sounds.keys():
		var audio_stream: AudioStreamPlayer = _sounds.get(sound_path)
		if audio_stream and audio_stream.playing == false:
			print_debug("Restarting audio for " + sound_path)
			audio_stream.play()


# Currently, only allows one instance of a sound file to play
func play_sound(type: AudioType, path: String):
	var audio_stream: AudioStreamPlayer = _sounds.get(path)
	if not audio_stream:
		audio_stream = AudioStreamPlayer.new()
		add_child(audio_stream)
		audio_stream.stream = load(path)
		
		if type == AudioType.PERSISTENT:
			_sounds.set(path, audio_stream)
#			
		else:
			audio_stream.play()
			
			# Clean up stream resource
			await audio_stream.finished
			audio_stream.queue_free()


func free_all_persistent_audio():
	for sound_path in _sounds.keys():
		var audio_stream: AudioStreamPlayer = _sounds.get(sound_path)
		if audio_stream:
			if audio_stream.playing:
				audio_stream.stop()
			audio_stream.queue_free()
		_sounds.erase(sound_path)
