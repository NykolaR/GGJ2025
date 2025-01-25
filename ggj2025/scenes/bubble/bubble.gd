extends RigidBody3D

enum MODE {TAP, PUSH}

@export var mode: MODE = MODE.TAP
@export var mult_dist: float = 40.0
@export var tap_intensity: float = 400.0
@export var intensity: Vector3 = Vector3(10, 10, 0.01)
@export var camera_sens_mult: float = 0.01

@onready var camera_y: Node3D = $Camera/CameraY as Node3D
@onready var camera_x: Node3D = $Camera/CameraY/CameraX as Node3D
@onready var camera: Camera3D = $Camera/CameraY/CameraX/Camera3D as Camera3D
@onready var big_ant: Node3D = $Camera/CameraY/CameraX/BigAnt as Node3D
@onready var ant: Node3D = $Camera/CameraY/CameraX/BigAnt/Ant as Node3D
@onready var frog: Node3D = $frog as Node3D

@onready var cooldown: Timer = $Timer as Timer

var direction: Vector3 = Vector3()


func _ready() -> void:
	if mode == MODE.TAP:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_unlock"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		var speed: Vector2 = event.relative * camera_sens_mult
		camera_y.rotate_y(-speed.x)
		camera_x.rotate_x(-speed.y)
		camera_x.rotation_degrees.x = clampf(camera_x.rotation_degrees.x, -87, 87)


func _physics_process(delta: float) -> void:
	match mode:
		MODE.TAP:
			tap_input(delta)
		MODE.PUSH:
			mouse_input(delta)


func tap_input(delta: float) -> void:
	if cooldown.is_stopped():
		var input: Vector3 = Vector3()
		input.x = Input.get_axis("tap_left", "tap_right")
		input.y = Input.get_axis("tap_down", "tap_up")
		input.z = Input.get_axis("tap_forward", "tap_backward")
		if not input.is_zero_approx():
			input = camera_x.to_global(input)
			frog.look_at(input)
			input -= global_position
			apply_central_force(input * tap_intensity)
			cooldown.start()


func mouse_input(delta: float) -> void:
	var mp2d: Vector2 = get_viewport().get_mouse_position() / Vector2(get_viewport().get_size())
	mp2d -= Vector2(0.5, 0.5)
	mp2d *= 2.0
	big_ant.rotation_degrees = Vector3(mp2d.y * 90, mp2d.x * 90, 0)# * abs(mp2d.length())
	var force: Vector3 = global_position - ant.global_position
	apply_central_force(force)


func funny() -> void:
	pass
