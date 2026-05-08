extends Node

signal pulse
var oldscore = playervars.oldhiscore
@export var scorelabel: Label

func _ready():
	if playervars.hiscore > oldscore:
		scorelabel.text = "  NEW RECORD  \nCURRENT SCORE: %s\nPREVIOUS HIGH SCORE: %s" % [playervars.score, oldscore]
		pulse.emit()
		playervars.oldhiscore = playervars.hiscore
	else:
		scorelabel.text = "SCORE: %s\nHIGH SCORE: %s" % [playervars.score, playervars.hiscore]

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		await get_tree().create_timer(0.2).timeout
		loadinghandler.initiateloadingscreen("res://scenes/screens/main.tscn")
		queue_free()
	
	if Input.is_action_just_pressed("quit"):
		print("quitting to title screen...")
		loadinghandler.initiateloadingscreen("res://scenes/screens/titlescreen.tscn")
		queue_free()

func _on_pulse():
	while true:
		if not is_inside_tree():
			return
		await get_tree().create_timer(1).timeout
		if not is_inside_tree():
			return
		scorelabel.text = "! NEW RECORD !\nCURRENT SCORE: %s\nPREVIOUS HIGH SCORE: %s" % [playervars.score, oldscore]
		await get_tree().create_timer(1).timeout
		scorelabel.text = "  NEW RECORD  \nCURRENT SCORE: %s\nPREVIOUS HIGH SCORE: %s" % [playervars.score, oldscore]
