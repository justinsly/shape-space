extends Node

signal pulse
var oldscore = playervars.oldhiscore
@export var game: PackedScene

func _ready():
	if playervars.hiscore > oldscore:
		$UI/score.text = "  NEW RECORD  \nCURRENT SCORE: %s\nPREVIOUS HIGH SCORE: %s" % [playervars.score, oldscore]
		pulse.emit()
		playervars.oldhiscore = playervars.hiscore
	else:
		$UI/score.text = "SCORE: %s\nHIGH SCORE: %s" % [playervars.score, playervars.hiscore]

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_packed(game)
	

func _on_pulse():
	while true:
		var delta = get_process_delta_time()
		if not is_inside_tree():
			return
		await get_tree().create_timer(1).timeout
		if not is_inside_tree():
			return
		$UI/score.text = "! NEW RECORD !\nCURRENT SCORE: %s\nPREVIOUS HIGH SCORE: %s" % [playervars.score, oldscore]
		await get_tree().create_timer(1).timeout
		$UI/score.text = "  NEW RECORD  \nCURRENT SCORE: %s\nPREVIOUS HIGH SCORE: %s" % [playervars.score, oldscore]
