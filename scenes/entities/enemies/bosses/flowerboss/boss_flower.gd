extends Enemy

@export var fatbulletscene: PackedScene
@export var bulletscene: PackedScene
signal finishedpattern
var bulletsfired := 0
@onready var shooterarray := [%top_petalshooter_left, %bottom_petalshooter_right, %top_petalshooter_right, %bottom_petalshooter_left, %left_petalshooter_top, %right_petalshooter_bottom, %left_petalshooter_bottom, %right_petalshooter_top]
@onready var petalshooters: Node2D = $petalshooters

func fire(shooter: Marker2D, shootspeed:= 100):
	var bullet = bulletscene.instantiate()
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
		var bullet = fatbulletscene.instantiate()
		bullet.position = position
		bullet.look_at(playerpos)
		bullet.rotate(deg_to_rad(90))
		add_sibling(bullet)
		bullet.shoot(250)
	finishedpattern.emit()

func _ready() -> void:
	flowerpattern()

func _process(_delta: float) -> void:
	pass


func _on_finishedpattern() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(petalshooters, "rotation_degrees", rotation_degrees + 5, 0.5)
	tween.tween_callback(flowerpattern)
