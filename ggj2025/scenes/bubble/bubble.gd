extends RigidBody3D

enum MODE {TAP, PUSH}

@export var mode: MODE = MODE.TAP
@export var mult_dist: float = 40.0
@export var tap_intensity: float = 400.0
@export var intensity: Vector3 = Vector3(10, 10, 0.01)
@export var camera_sens_mult: float = 0.01

@onready var camera_y: Node3D = $Camera/CameraY as Node3D
@onready var camera_x: Node3D = $Camera/CameraY/CameraX as Node3D
@onready var camera: Camera3D = $Camera/CameraY/CameraX/SpringArm3D/Camera3D as Camera3D
@onready var big_ant: Node3D = $Camera/CameraY/CameraX/BigAnt as Node3D
@onready var ant: Node3D = $Camera/CameraY/CameraX/BigAnt/Ant as Node3D
@onready var frog_visual: Node3D = $Frog/frog as Node3D
@onready var frog: RigidBody3D = $Frog as RigidBody3D

@onready var cooldown: Timer = $Timer as Timer

@onready var animation: AnimationPlayer = $"Frog/frog/frog-fix-2/AnimationPlayer" as AnimationPlayer
@onready var swim_audio: AudioStreamPlayer3D = $Swim as AudioStreamPlayer3D

var shader: ShaderMaterial
var bubble_control: bool = true
var vstack: Array[Vector3] = []

var frog_scored
var direction: Vector3 = Vector3()

signal frog_popped(node: Node3D)
signal calculate_score(node: Node3D)
signal tap_inputted(direction: Vector3)
signal restart

func _ready() -> void:
	shader = $MeshInstance3D.material_override
	if mode == MODE.TAP:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		animation.play("Animation")
		animation.seek(2.5, true, true)


func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event.is_action_pressed("mouse_unlock"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		if bubble_control and event is InputEventMouseMotion:
			var speed: Vector2 = event.relative * camera_sens_mult
			camera_y.rotate_y(-speed.x)
			camera_x.rotate_x(-speed.y)
			camera_x.rotation_degrees.x = clampf(camera_x.rotation_degrees.x, -87, 87)
		
		if event.is_action_pressed("restart"):
			restart.emit()
			
	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		if event.is_action_pressed("mouse_unlock"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if bubble_control:
		match mode:
			MODE.TAP:
				tap_input(delta)
			MODE.PUSH:
				mouse_input(delta)
		var vl: float = linear_velocity.length()
		shader.set_shader_parameter("fuwafuwa_speed", remap(clampf(vl, 0, 10), 0, 10, 1.5, 2.5))
		shader.set_shader_parameter("fuwafuwa_size", remap(clampf(vl, 0, 10), 0, 10, 0.05, 0.1))
		if Input.is_action_just_pressed("pop"):
			pop()
		else:
			if vstack.size() < 5:
				vstack.append(linear_velocity)
			else:
				vstack.push_front(linear_velocity)
				vstack.pop_back()
	else:
		camera.look_at(frog.global_position)
	animation.advance(delta * 3.0)


func _process(delta: float) -> void:
	if bubble_control:
		var speed: Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * delta * 10.0
		camera_y.rotate_y(-speed.x)
		camera_x.rotate_x(-speed.y)
		camera_x.rotation_degrees.x = clampf(camera_x.rotation_degrees.x, -87, 87)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var i: int = 0
	while i < state.get_contact_count():
		var normal: Vector3 = state.get_contact_local_normal(i)
		var lv: Vector3 = vstack.back()
		var dot: float = lv.normalized().dot(normal) * clampf(lv.length(), 0.1, 2.5)
		if dot < -0.8:
			pop()
			return
		i += 1


func tap_input(_delta: float) -> void:
	if cooldown.is_stopped():
		var input: Vector3 = Vector3()
		input.x = Input.get_axis("tap_left", "tap_right")
		input.y = Input.get_axis("tap_down", "tap_up")
		input.z = Input.get_axis("tap_forward", "tap_backward")
		if not input.is_zero_approx():
			tap_inputted.emit(input)
			input = camera_x.to_global(input)
			frog.look_at(input)
			input -= global_position
			apply_central_force(input * tap_intensity)
			animation.play("Animation")
			cooldown.start()
			swim_audio.play()


func mouse_input(_delta: float) -> void:
	var mp2d: Vector2 = get_viewport().get_mouse_position() / Vector2(get_viewport().get_size())
	mp2d -= Vector2(0.5, 0.5)
	mp2d *= 2.0
	big_ant.rotation_degrees = Vector3(mp2d.y * 90, mp2d.x * 90, 0)# * abs(mp2d.length())
	var force: Vector3 = global_position - ant.global_position
	apply_central_force(force)


func pop() -> void:
	$MeshInstance3D.hide()
	if has_node("Frog/RemoteTransform3D"):
		$Frog/RemoteTransform3D.queue_free()
	if has_node("Frog/RemoteTransform3D2"):
		$Frog/RemoteTransform3D2.queue_free()
	bubble_control = false
	frog.process_mode = Node.PROCESS_MODE_PAUSABLE
	frog.linear_velocity = linear_velocity
	frog.angular_velocity = angular_velocity
	$Bindle.process_mode = Node.PROCESS_MODE_PAUSABLE
	$Bindle.linear_velocity = linear_velocity
	$Bindle.angular_velocity = angular_velocity
	$CricketJam.process_mode = Node.PROCESS_MODE_PAUSABLE
	$CricketJam.linear_velocity = linear_velocity
	$CricketJam.angular_velocity = angular_velocity
	freeze = true
	$Pop.play()
	frog_popped.emit(frog)
	$FrogTimer.start()
	$Music.stop()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	swim_audio.stop()


func _on_frog_timer_timeout() -> void:
	score_frog()


func _on_frog_sleeping_state_changed() -> void:
	score_frog()


func score_frog() -> void:
	if not bubble_control and not frog_scored:
		frog_scored = true
		frog.freeze = true
		calculate_score.emit(frog)


func _on_frog_body_entered(body: Node) -> void:
	$Frog/Bonk.play()
