extends Node2D

func _ready() -> void:
	var nextscene = load(loadinghandler.scenetoload)
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_packed(nextscene)
