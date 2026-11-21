extends Enemy

@export var fatbulletscene: PackedScene
@export var bulletscene: PackedScene
signal finishedpattern
var bulletsfired := 0
@onready var shooterarray := [%top_petalshooter_left, %bottom_petalshooter_right, %top_petalshooter_right, %bottom_petalshooter_left, %left_petalshooter_top, %right_petalshooter_bottom, %left_petalshooter_bottom, %right_petalshooter_top]
@onready var petalshooters: Node2D = $petalshooters

# i see lots of people say "if you are gonna make a game with lots of objects
#                           then you should implement object pooling!!"
# so i have looked into how it works
# seems pretty cool
# i just gotta figure out how the fuck would i implement something like that
# and then finally this boss will stop causing framerate drops by just existing
#
# update: i tried an implementation, the spawning seems to work at first,
#         but then the whole thing just shits itself after the first iteration,
#         bullets would just randomly disappear for some reason, and it would
#         accumulate a crap ton of bullet nodes in the tree

func fire(shooter: Marker2D, shootspeed:= 100):
	var bullet := bulletscene.instantiate()
	bullet.rotation = shooter.global_rotation
	bullet.position = shooter.global_position
	add_sibling.call_deferred(bullet)
	bullet.shoot(shootspeed)

func flowerpattern():
	$AnimationPlayer.play("flowerpattern")
	while bulletsfired <= 100:
		for i in shooterarray:
			fire(i)
		bulletsfired += 8
		if bulletsfired <= 100:
			await get_tree().create_timer(0.25).timeout
	bulletsfired = 0
	var deg := 0
	for i in 22:
		var bullet = fatbulletscene.instantiate()
		bullet.position = position
		bullet.rotation = deg
		add_sibling(bullet)
		bullet.shoot(100)
		deg += 2
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var playerpos:Vector2 = player.global_position
		var extradeg := 80
		for i in 3:
			var bullet = fatbulletscene.instantiate()
			bullet.position = position
			bullet.look_at(playerpos)
			bullet.rotate(deg_to_rad(extradeg))
			add_sibling(bullet)
			bullet.shoot(250)
			extradeg += 10
	finishedpattern.emit()

func _process(_delta: float) -> void:
	pass


func _on_finishedpattern() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(petalshooters, "rotation_degrees", rotation_degrees + 15, 0.5)
	tween.tween_callback(flowerpattern)

func _on_initialized() -> void:
	if !is_node_ready():
		await ready
	var tween := create_tween()
	
	tween.tween_property(self, "position:y", position.y + 124, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(flowerpattern)


func _on_die() -> void:
	for bullet in get_tree().get_nodes_in_group("bullet"):
		bullet.queue_free()
