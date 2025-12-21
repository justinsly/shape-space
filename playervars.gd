extends Node

var health := 3
var score := 0
var hiscore := 0
var oldhiscore := 0

func save_score():
	# i should probably make the save data a binary file
	# so that people wouldnt be able to easily tinker with it
	var save_dict = {
		"hiscore" : hiscore,
		"oldhiscore" : oldhiscore
	}
	return save_dict

func load_score():
	# im just going off what the official documentation is saying,
	# managing files is scary.
	# future jayden here: ok i think i kinda get it
	if not FileAccess.file_exists("user://scoredata.jden"):
		print("could not load save data: file doesnt exist")
		return
	
	var save_file = FileAccess.open("user://scoredata.jden", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			printerr("JSON parse error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var data = json.data
		print(data)
		hiscore = data["hiscore"]
		oldhiscore = data["oldhiscore"]
	print("save data loaded")

func _ready():
	print("loading save data...")
	load_score()
