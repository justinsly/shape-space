extends Node

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		print("pause action")
		get_tree().paused = not get_tree().paused
		$"../pauseHUD".visible = not $"../pauseHUD".visible
		print($"../pauseHUD".visible, get_tree().paused)
