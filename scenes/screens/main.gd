extends Node

## the list of enemies that can be spawned.[br]
## to add a new entry: click on "Add Element" and then select a scene
@export var spawnable_enemies: Array[PackedScene]
@export var rare_spawnable_enemies: Array[PackedScene] ## this list of enemies should rarely spawn
@export var bosses: Array[PackedScene] ## list of bosses (duh)
@export var HiscoreLabel: Label
@export var ScoreLabel: Label
@export var HealthHud: Sprite2D
@export var enemyspawner: Timer
var currentboss: Enemy
var bosstime := false
var kills_tillboss := 15

func _ready():
	HiscoreLabel.text = str(playervars.hiscore)
	playervars.health = 3
	playervars.score = 0
	playervars.oldhiscore = playervars.hiscore
	if playervars.showfps:
		var fpsdisplay = preload("res://scenes/fpsdisplay.tscn").instantiate()
		add_child(fpsdisplay)
	print("main scene ready!")

func _on_enemyspawner_timeout():
	if bosstime:
		return
	var sceneenemy = spawnable_enemies.pick_random()
	if randi_range(1, 10) == 10:
		sceneenemy = spawnable_enemies.pick_random() # change this to rare_spawnable_enemies once we actually add enemies to that list
	#print(sceneenemy)
	var enemy = sceneenemy.instantiate()
	enemy.initialize(randf_range(44.0, 645.0), -47)
	add_child(enemy)

func _on_player_hit():
	HealthHud.frame = playervars.health
	if playervars.health <= 1:
		$HUD/Healthwarning/AnimationPlayer.play("healthwarningbeep")

func _on_player_heal():
	HealthHud.frame = playervars.health
	if playervars.health > 1:
		$HUD/Healthwarning/AnimationPlayer.play("RESET")


func _on_scoremanager_update():
	ScoreLabel.text = str(playervars.score)
	HiscoreLabel.text = str(playervars.hiscore)
	if kills_tillboss > 0:
		kills_tillboss -= 1
	
	# FIXME: this shit gets intense the moment you reach a score of 3
	#$enemyspawner.wait_time = $enemyspawner.wait_time + (((playervars.score * 0.5) * -1) + 0.4)
	#print(str($enemyspawner.wait_time))
	
	# its quite lenghty i know
	if kills_tillboss <= 0 && randi_range(0, 25) >= 17 && !bosstime || playervars.score >= 15 && playervars.guaranteeboss && !bosstime:
		print("BOSS TIME!!!")
		kills_tillboss = 16
		var bossscene = bosses.pick_random()
		print("boss picked: ", bossscene)
		bosstime = true
		await get_tree().create_timer(3).timeout
		currentboss = bossscene.instantiate()
		currentboss.die.connect(_on_boss_death)
		currentboss.initialize(348, -47)
		add_child(currentboss)

func _on_boss_death():
	bosstime = false

func _on_player_explode():
	await get_tree().create_timer(2).timeout
	if playervars.hiscore > playervars.oldhiscore:
		playervars.save_data()
	
	get_tree().paused = false
	print("going to game over screen...")
	for evilbitch in get_tree().get_nodes_in_group("enemy"):
		print_verbose("deleting ", evilbitch, " to prevent potential crashes!!!")
		if evilbitch:
			evilbitch.free()
	$HUD/Healthwarning/AnimationPlayer.play("RESET")
	loadinghandler.initiateloadingscreen("res://scenes/screens/arcadegameover.tscn", true)
