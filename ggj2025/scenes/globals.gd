extends Node

var audioPosition = 0.0

func set_audio_position (ap: float ) -> void:
	audioPosition = ap
	
func get_audio_position () -> float:
	return audioPosition
