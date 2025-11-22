extends Node

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		print("pause action")
		if get_tree().is_paused:
			get_tree().paused = false
			$"../pauseHUD".hide()
		else:
			get_tree().paused = true
			$"../pauseHUD".show()
