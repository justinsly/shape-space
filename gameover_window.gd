extends AcceptDialog

# NOTE: i have no idea on what am i doing anymore man
#       i just type and hope that stuff works

func _ready():
	add_cancel_button("quit")
	
func _on_about_to_popup():
	if playervars.hiscore > playervars.oldhiscore:
		dialog_text = "NEW HIGH SCORE\nold high score: %s new high score: %s" % [playervars.oldhiscore, playervars.hiscore]
		playervars.oldhiscore = playervars.hiscore
	else:
		dialog_text = "GAME OVER\nhigh score: %s\ncurrent score: %s" % [playervars.hiscore, playervars.score]



func _on_confirmed():
	playervars.score = 0
	playervars.health = 3
	hide()
	get_tree().reload_current_scene()
