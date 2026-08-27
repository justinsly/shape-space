extends Node

@onready var mvolumecounter := $UI/TabContainer/Audio/musicvolumecounter
@onready var sfxvolumecounter := $UI/TabContainer/Audio/sfxvolumecounter
@onready var mvolumeslider := $UI/TabContainer/Audio/musicvolumeslider
@onready var sfxvolumeslider := $UI/TabContainer/Audio/sfxvolumeslider

func _ready():
	$UI/backbutton.grab_focus()
	mvolumeslider.value = playervars.musicvolume
	sfxvolumeslider.value = playervars.sfxvolume
	mvolumecounter.text = str(roundi(mvolumeslider.value))
	sfxvolumecounter.text = str(roundi(sfxvolumeslider.value))

func _on_backbutton_pressed():
	loadinghandler.initiateloadingscreen("res://scenes/screens/titlescreen.tscn")


func _on_musicvolumeslider_value_changed(value: float):
	mvolumecounter.text = str(roundi(value))

func _on_sfxvolumeslider_value_changed(value: float):
	sfxvolumecounter.text = str(roundi(value))

func _on_applybutton_pressed():
	playervars.musicvolume = mvolumeslider.value
	playervars.sfxvolume = sfxvolumeslider.value
	match $UI/TabContainer/Video/OptionButton.selected:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			playervars.windowmode = 0
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			playervars.windowmode = 1
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			playervars.windowmode = 2
	playervars.savesettings()
