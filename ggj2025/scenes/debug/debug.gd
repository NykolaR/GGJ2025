extends Node3D

var time: float = 0.0
var pop_location: Vector3 = Vector3.ZERO


func _ready() -> void:
	frog_popped(self)
	time = 151
	_on_bubble_calculate_score(self)


func _process(delta: float) -> void:
	time += delta


func frog_popped(frog: Node3D) -> void:
	set_process(false)
	pop_location = frog.global_position


func _on_bubble_calculate_score(node: Node3D) -> void:
	var base_score: int = $Cave/Landing.get_score()
	var dist: int = node.global_position.distance_to(pop_location)
	var time_mult: int = clampf(5 - ((time - 30) / 30), 1, 5)
	
