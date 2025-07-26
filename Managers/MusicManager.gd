extends AudioStreamPlayer
const AQUATIC_CONNECTION = preload("res://Assets/Music/AquaticConnection.ogg")
const CONNECT_THE_DOTS = preload("res://Assets/Music/ConnectTheDots.ogg")

const FADE_OUT_TIME = 0.4
var tween: Tween

func stop_track():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(self, "volume_linear", 0, FADE_OUT_TIME)
	
	await tween.finished

func play_track(track: AudioStream):
	if is_playing():
		await stop_track()
	volume_linear = 1
	stream = track
	play()
