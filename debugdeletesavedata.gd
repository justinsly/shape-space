extends Button
var timeron := false
var ogtext := text

func _on_pressed():
	if timeron:
		if FileAccess.file_exists("user://scoredata.jden"):
			var dir = DirAccess.open("user://")
			dir.remove("user://scoredata.jden")
			playervars.hiscore = 0
			playervars.oldhiscore = 0
			print("SAVE DATA ERASED, AS IF IT WAS NEVER THERE")
		$Timer.stop()
		$Timer.timeout.emit()
	else:
		text = "ARE YOU SURE?"
		$Timer.start()
		timeron = true


func _on_timer_timeout():
	timeron = false
	text = ogtext
