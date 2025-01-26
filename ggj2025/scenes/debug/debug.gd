extends Node3D

var time: float = 0.0
var pop_location: Vector3 = Vector3.ZERO


func _process(delta: float) -> void:
	time += delta


func frog_popped(frog: Node3D) -> void:
	set_process(false)
	pop_location = frog.global_position


func _on_bubble_calculate_score(node: Node3D) -> void:
	var base_score: int = $Cave/Landing.get_score()
	var dist: float = node.global_position.distance_to(pop_location)
	var time_mult: int = clampf(5 - ((time - 30) / 30), 1, 5)
	var dist_mult: int = floori(dist)
	
	$CanvasLayer/ScoreDisplay/BaseValue.text = str(base_score)
	$CanvasLayer/ScoreDisplay/TimeMultValue.text = "Time: " + ("%10.2f" % time) + " seconds -> x" + str(time_mult)
	$CanvasLayer/ScoreDisplay/LaunchMultValue.text = "Distance: " + ("%10.2f" % dist) + "m -> x" + str(dist_mult)# 0.07
	$CanvasLayer/ScoreDisplay/FinalScoreValue.text = str(base_score * time_mult * dist_mult)
	
	$CanvasLayer/Timer.start()
	for child in $CanvasLayer/ScoreDisplay.get_children():
		child.show()
		await $CanvasLayer/Timer.timeout
	$CanvasLayer/Timer.stop()


func _on_bubble_restart() -> void:
	get_tree().reload_current_scene()
