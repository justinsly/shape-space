extends Node

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().paused = not get_tree().paused
		$"../pauseHUD".visible = not $"../pauseHUD".visible
