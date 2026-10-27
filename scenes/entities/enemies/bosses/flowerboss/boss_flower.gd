extends Enemy

@export var fatbulletscene: PackedScene
@export var bulletscene: PackedScene
signal finishedpattern
var flowershooting := true
var bulletsfired := 0

func fire(shooter: Marker2D, shootspeed:= 100):
	var bullet = bulletscene.instantiate()
	bullet.rotation = shooter.global_rotation
	bullet.position = shooter.global_position
	add_sibling.call_deferred(bullet)
	bullet.shoot(shootspeed)

func flowerpattern():
	$AnimationPlayer.play("flowerpattern")
	while flowershooting && bulletsfired <= 100:
		fire(%top_petalshooter_left)
		fire(%bottom_petalshooter_right)
		fire(%top_petalshooter_right)
		fire(%bottom_petalshooter_left)
		fire(%left_petalshooter_top)
		fire(%right_petalshooter_bottom)
		fire(%left_petalshooter_bottom)
		fire(%right_petalshooter_top)
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
	finishedpattern.emit()

func _ready() -> void:
	flowerpattern()

func _process(_delta: float) -> void:
	pass


func _on_finishedpattern() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + 5, 0.5)
	tween.tween_callback(flowerpattern)
