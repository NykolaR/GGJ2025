extends CharacterBody3D


func _physics_process(delta: float) -> void:
	var mp: Vector2 = get_viewport().get_mouse_position()
	print(mp / get_viewport().size())
	var force: Vector3 = Vector3()
	


func funny() -> void:
	pass
