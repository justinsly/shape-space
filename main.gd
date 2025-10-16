extends Node

## the enemy scene, preloaded for quick access
@export var sceneenemy: PackedScene

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	$HUD/HiscoreLabel.text = "HI score: %s" % playervars.hiscore
	playervars.health = 3
	playervars.score = 0

func _on_enemyspawner_timeout():
	var enemy = sceneenemy.instantiate()
	enemy.initialize(randf_range(8.0, 1144.0), -47)
	add_child(enemy)


func _on_player_hit():
	$HUD/HealthLabel.text = "health: %s" % playervars.health

func _on_player_heal():
	$HUD/HealthLabel.text = "health: %s" % playervars.health


func _on_scoremanager_update():
	$HUD/ScoreLabel.text = "score: %s" % playervars.score
	$HUD/HiscoreLabel.text = "HI score: %s" % playervars.hiscore



func _on_player_explode():
	await get_tree().create_timer(2).timeout
	# WARNING: when i finally decide to organize the game files,
	# dont forget to change this file path
	get_tree().change_scene_to_file("res://arcadegameover.tscn")
