extends Node

@onready var fadeout := $UI/fadeout

func _ready():
	$UI/hiscoretext.text = "high score: %s" % playervars.hiscore
	$UI/startbutton.grab_focus()

func _on_startbutton_pressed():
	for i in $UI.get_children():
		if i.is_class("Button"):
			i.disabled = true
	fadeout.show()
	while fadeout.position.y > 0:
		var delta = get_process_delta_time()
		fadeout.position.y -= 450 * delta
		await get_tree().create_timer(delta).timeout
		if fadeout.position.y <= 0:
			loadinghandler.initiateloadingscreen("res://scenes/screens/main.tscn")

func _on_optionsbutton_pressed():
	loadinghandler.initiateloadingscreen("res://scenes/screens/settingsscreen.tscn")

func _on_quitbutton_pressed():
	get_tree().quit()


func _on_statsbutton_pressed() -> void:
	$Popup.popup()
	$Popup/closebutton.grab_focus()


func _on_closebutton_pressed() -> void:
	$Popup.hide()
