extends Node2D

func _ready() -> void:
	var nextscene = load(loadinghandler.scenetoload)
	if !loadinghandler.loadfaster:
		await get_tree().create_timer(0.2).timeout
	print("loading: ", nextscene)
	get_tree().change_scene_to_packed(nextscene)
	loadinghandler.loadfaster = false
