class_name tutorial

extends Node3D

@onready var textlabel = $CanvasLayer/RichTextLabel

static var states = {
	"Move Up (W, D-Up)": false,
	"Move Down (S, D-Down)": false,
	"Move Left (A, D-Left)": false,
	"Move Right (D, D-Right)": false,
	"Move Forward (Left Click, R Bumper)": false,
	"Move Backward (Right Click, L Button)": false,
	"Restart (R, Select)": false,
	"Pop (Space, (X) )": false,
	"Land": false
}

func update_text ():
	textlabel.text = ""
	for key in states.keys():
		if states[key] == false:
			textlabel.append_text(key + "\n")
		else:
			textlabel.append_text("[s]" + key + "[/s]\n")
			
func _ready ():
	update_text()


func _on_bubble_tap_inputted(direction: Vector3) -> void:
	if direction.is_equal_approx(Vector3(1.0,0,0)):
		states["Move Right (D, D-Right)"] = true
	elif direction.is_equal_approx(Vector3(-1.0,0,0)):
		states["Move Left (A, D-Left)"] = true
	elif direction.is_equal_approx(Vector3(0,1.0,0)):
		states["Move Up (W, D-Up)"] = true
	elif direction.is_equal_approx(Vector3(0,-1.0,0)):
		states["Move Down (S, D-Down)"] = true
	elif direction.is_equal_approx(Vector3(0,0,1.0)):
		states["Move Backward (Right Click, L Button)"] = true
	elif direction.is_equal_approx(Vector3(0,0,-1.0)):
		states["Move Forward (Left Click, R Bumper)"] = true
	update_text()
	
	


func _on_bubble_restart() -> void:
	states["Restart (R, Select)"] = true
	get_tree().reload_current_scene()
	


func _on_bubble_frog_popped() -> void:
	states["Pop (Space, (X) )"] = true
	update_text()


func _on_bubble_calculate_score() -> void:
	print ("called")
	states["Land"] = true
	update_text()
