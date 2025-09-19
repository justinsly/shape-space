extends Node

## the enemy scene, preloaded for quick access
@export var sceneenemy: PackedScene

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0))

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
