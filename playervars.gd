extends Node
# saves locations
const SCORESAVEFILE := "user://scoredata.jden" ## string path for scoredata.jden file
const SETTINGSFILE := "user://settings.cfg" ## string path for settings.cfg file
# player stats
var health := 3
var score := 0
var hiscore := 0
var oldhiscore := 0
# settings
var mastervolume := 100
var musicvolume := 50
var sfxvolume := 50
var windowmode := 0

func return_savedict():
	# i should probably make the save data a binary file
	# so that people wouldnt be able to easily tinker with it
	var save_dict = {
		"hiscore" : hiscore,
		"oldhiscore" : oldhiscore
	}
	return save_dict

## saves all options to a config file
func savesettings():
	var config = ConfigFile.new()
	config.set_value("audio", "mastervol", mastervolume)
	config.set_value("audio", "musicvol", musicvolume)
	config.set_value("audio", "sfxvol", sfxvolume)
	config.set_value("video", "windowmode", windowmode)
	config.save(SETTINGSFILE)
	print("settings saved")

func loadsettings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGSFILE)
	if err != OK:
		print("could not load config file")
		return
	
	for section in config.get_sections():
		match section:
			"audio":
				mastervolume = config.get_value(section, "mastervol", 100)
				musicvolume = config.get_value(section, "musicvol", 50)
				sfxvolume = config.get_value(section, "sfxvol", 50)
			"video":
				windowmode = config.get_value(section, "windowmode", 0)
	print("settings loaded")

func save_data():
	var save_file = FileAccess.open(SCORESAVEFILE, FileAccess.WRITE)
	var s_data = return_savedict()
	var json_string = JSON.stringify(s_data)
	
	save_file.store_line(json_string)
	print("data saved")

func load_score():
	# im just going off what the official documentation is saying,
	# managing files is scary.
	# future jayden here: ok i think i kinda get it
	if not FileAccess.file_exists(SCORESAVEFILE):
		print("could not load save data: file doesnt exist")
		return
	
	var save_file = FileAccess.open(SCORESAVEFILE, FileAccess.READ)
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
	print("loading config...")
	loadsettings()
	print("setting window mode...")
	match windowmode:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
