extends Node

func _ready():
	$UI/hiscoretext.text = "high score: %s" % playervars.hiscore

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene_to_file("res://main.tscn")
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
