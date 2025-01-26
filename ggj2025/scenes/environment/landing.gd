extends StaticBody3D


func get_score() -> int:
	var score: int = 0
	score += $"10".get_overlapping_bodies().size() * 10
	score += $"30".get_overlapping_bodies().size() * 20
	score += $"50".get_overlapping_bodies().size() * 20
	return score
