extends Node

func _ready():
	$UI/backbutton.grab_focus()

func _on_backbutton_pressed():
	loadinghandler.initiateloadingscreen("res://scenes/screens/titlescreen.tscn")
