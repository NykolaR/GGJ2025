extends Node

var tween:Tween = create_tween()  

#Then set it on _ready()
func _ready():    
	#First parameter is what to affect.  
	#Second the property of said object to affect  
	#Third is what value you want it to end on.  
	#Fourth is the time taken to do so.
	tween.tween_property($CanvasLayer/ColorRect,"modulate", Color(0,0,0,1), 1)
	tween.stop()

func _on_button_pressed() -> void:
	tween.play()
	tween.connect("finished", title)

func title ():
	get_tree().change_scene_to_file("res://scenes/title/title.tscn")
