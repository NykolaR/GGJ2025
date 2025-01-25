extends RigidBody3D

@export var mult_dist: float = 40.0
@export var intensity: Vector3 = Vector3(10, 10, 0.01)

@onready var camera: Camera3D = $Camera/CameraX/CameraY/Camera3D as Camera3D
@onready var big_ant: Node3D = $Camera/CameraX/CameraY/BigAnt as Node3D
@onready var ant: Node3D = $Camera/CameraX/CameraY/BigAnt/Ant as Node3D

func _physics_process(delta: float) -> void:
	var mp2d: Vector2 = get_viewport().get_mouse_position() / Vector2(get_viewport().get_size())
	mp2d -= Vector2(0.5, 0.5)
	mp2d *= 2.0
	big_ant.rotation_degrees = Vector3(mp2d.y * 90, mp2d.x * 90, 0)# * abs(mp2d.length())
	var force: Vector3 = global_position - ant.global_position
	apply_central_force(force)


func funny() -> void:
	pass
