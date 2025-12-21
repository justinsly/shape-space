extends Button
var timeron := false
# NOTE: please kill (delete) this beast (node) and its partner (the script)
# once we make a proper way to reset save data

func _on_pressed():
	if timeron:
		if FileAccess.file_exists("user://scoredata.jden"):
			var dir = DirAccess.open("user://")
			dir.remove("user://scoredata.jden")
			playervars.hiscore = 0
			playervars.oldhiscore = 0
			$"../UI/hiscoretext".text = "high score: 0"
			print("SAVE DATA ERASED, AS IF IT WAS NEVER THERE")
		$Timer.stop()
		$Timer.timeout.emit()
	else:
		text = "ARE YOU SURE?"
		$Timer.start()
		timeron = true


func _on_timer_timeout():
	timeron = false
	text = "evil save data deletion button"
