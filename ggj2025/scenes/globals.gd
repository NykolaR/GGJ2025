extends Node

var audioPosition = 0.0

func set_audio_position (ap: float ) -> void:
	print (ap)
	audioPosition = ap
	
func get_audio_position () -> float:
	print (audioPosition)
	return audioPosition
