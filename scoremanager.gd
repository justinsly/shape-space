extends Node

signal update 

var oldscore := 0

func _process(delta):
	if oldscore != playervars.score:
		oldscore = playervars.score
		if playervars.score > playervars.hiscore:
			playervars.hiscore = playervars.score
		update.emit()
