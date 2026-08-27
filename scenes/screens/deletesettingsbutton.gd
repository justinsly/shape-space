extends Button
var timeron := false
var ogtext := text

func _on_pressed():
	if timeron:
		if FileAccess.file_exists(playervars.SETTINGSFILE):
			var dir = DirAccess.open("user://")
			dir.remove(playervars.SETTINGSFILE)
			playervars.mastervolume = 100
			playervars.musicvolume = 50
			playervars.sfxvolume = 50
			playervars.windowmode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print("settings resetted")
		$Timer.stop()
		$Timer.timeout.emit()
	else:
		text = "REALLY reset settings?"
		$Timer.start()
		timeron = true


func _on_timer_timeout():
	timeron = false
	text = ogtext
