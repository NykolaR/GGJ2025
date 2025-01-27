class_name tutorial

extends Node3D

@onready var textlabel = $CanvasLayer/RichTextLabel

var tween: Tween

static var states = {
	"Move Up (W / D-Up)": false,
	"Move Down (S / D-Down)": false,
	"Move Left (A / D-Left)": false,
	"Move Right (D / D-Right)": false,
	"Move Forward (Left Click / R Bumper)": false,
	"Move Backward (Right Click / L Bumper)": false,
	"Restart (R / Select)": false,
	"Pop (Space / X Button)": false,
	"Land and Unwind...": false
}

func update_text ():
	textlabel.text = ""
	for key in states.keys():
		if states[key] == false:
			textlabel.append_text(key + "\n")
			
	var overall_truth = true
	for key in states.keys():
		if states[key] == false:
			overall_truth = false
	if overall_truth:
		textlabel.text = "It's time to head off..."
		tween.play()
		tween.connect("finished", explore)

func _ready ():
	update_text()
	tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(0, 0, 0, 1), 2.0)
	tween.stop()

func _on_bubble_tap_inputted(direction: Vector3) -> void:
	if direction.is_equal_approx(Vector3(1.0,0,0)):
		states["Move Right (D / D-Right)"] = true
	elif direction.is_equal_approx(Vector3(-1.0,0,0)):
		states["Move Left (A / D-Left)"] = true
	elif direction.is_equal_approx(Vector3(0,1.0,0)):
		states["Move Up (W / D-Up)"] = true
	elif direction.is_equal_approx(Vector3(0,-1.0,0)):
		states["Move Down (S / D-Down)"] = true
	elif direction.is_equal_approx(Vector3(0,0,1.0)):
		states["Move Backward (Right Click / L Bumper)"] = true
	elif direction.is_equal_approx(Vector3(0,0,-1.0)):
		states["Move Forward (Left Click / R Bumper)"] = true
	update_text()
	
func _on_bubble_restart() -> void:
	states["Restart (R / Select)"] = true
	get_tree().reload_current_scene()

func _on_bubble_frog_popped(_a) -> void:
	states["Pop (Space / X Button)"] = true
	update_text()

func _on_bubble_calculate_score(_a) -> void:
	states["Land and Unwind..."] = true
	update_text()

func explore ():
	get_tree().change_scene_to_file("res://scenes/debug/debug.tscn")
