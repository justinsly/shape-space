extends Node

## the list of enemies that can be spawned.[br]
## to add a new entry: click on "Add Element" and then select a scene
@export var spawnable_enemies: Array[PackedScene]
@export var rare_spawnable_enemies: Array[PackedScene] ## this list of enemies should rarely spawn
@export var HiscoreLabel: Label
@export var ScoreLabel: Label
@export var HealthHud: Sprite2D

func _ready():
	HiscoreLabel.text = "HI score: %s" % playervars.hiscore
	playervars.health = 3
	playervars.score = 0
	playervars.oldhiscore = playervars.hiscore
	print("main scene ready!")

func save_data():
	var save_file = FileAccess.open("user://scoredata.jden", FileAccess.WRITE)
	var s_data = playervars.call("save_score")
	var json_string = JSON.stringify(s_data)
	
	save_file.store_line(json_string)
	print("data saved")

func _on_enemyspawner_timeout():
	var sceneenemy = spawnable_enemies.pick_random()
	if randi_range(1, 10) == 10:
		sceneenemy = spawnable_enemies.pick_random() # change this to rare_spawnable_enemies once we actually add enemies to that list
	#print(sceneenemy)
	var enemy = sceneenemy.instantiate()
	enemy.initialize(randf_range(208.0, 872.0), -47)
	add_child(enemy)

func _on_player_hit():
	HealthHud.frame = playervars.health

func _on_player_heal():
	HealthHud.frame = playervars.health


func _on_scoremanager_update():
	ScoreLabel.text = "score: %s" % playervars.score
	HiscoreLabel.text = "HI score: %s" % playervars.hiscore
	
	# FIXME: this shit gets intense the moment you reach a score of 3
	#$enemyspawner.wait_time = $enemyspawner.wait_time + (((playervars.score * 0.5) * -1) + 0.4)
	#print(str($enemyspawner.wait_time))



func _on_player_explode():
	var gameoverscreen = preload("res://scenes/screens/arcadegameover.tscn").instantiate()
	await get_tree().create_timer(2).timeout
	if playervars.hiscore > playervars.oldhiscore:
		save_data()
	
	get_tree().paused = false
	queue_free()
	add_sibling(gameoverscreen)


func _on_healthzone_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		HealthHud.modulate = Color(1, 1, 1, 0.5)


func _on_healthzone_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		HealthHud.modulate = Color(1, 1, 1, 1)
