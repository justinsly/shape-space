extends Node

func _ready():
	$UI/hiscoretext.text = "high score: %s" % playervars.hiscore

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		await get_tree().create_timer(0.5 * delta).timeout
		get_tree().change_scene_to_file("res://scenes/screens/main.tscn")
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
