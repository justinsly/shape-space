extends Node

@onready var mvolumecounter := $UI/TabContainer/Audio/musicvolumecounter
@onready var sfxvolumecounter := $UI/TabContainer/Audio/sfxvolumecounter
@onready var mvolumeslider := $UI/TabContainer/Audio/musicvolumeslider
@onready var sfxvolumeslider := $UI/TabContainer/Audio/sfxvolumeslider
@onready var backbutton: Button = $UI/backbutton

func _ready():
	$UI/backbutton.grab_focus()
	mvolumeslider.value = playervars.musicvolume
	sfxvolumeslider.value = playervars.sfxvolume
	mvolumecounter.text = str(roundi(mvolumeslider.value))
	sfxvolumecounter.text = str(roundi(sfxvolumeslider.value))
	$UI/TabContainer/Video/OptionButton.select(playervars.windowmode)
	$UI/TabContainer/Game/hitboxfocustoggle.set_pressed_no_signal(playervars.showfocushitbox)

func _on_backbutton_pressed():
	loadinghandler.initiateloadingscreen("res://scenes/screens/titlescreen.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		if get_viewport().gui_get_focus_owner() == backbutton:
			backbutton.pressed.emit()
		else:
			backbutton.grab_focus()

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
	playervars.showfocushitbox = $UI/TabContainer/Game/hitboxfocustoggle.button_pressed
	playervars.savesettings()
