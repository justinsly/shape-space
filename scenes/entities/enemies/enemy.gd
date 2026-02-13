extends Area2D

@export var health: int = 1 ## the starting health for the enemy
@export var movement_speed: int = 250 ## do i need to write a description for this
@export var bounce_on_hit: bool ## determines if the enemy should move backward a little bit upon hitting the player
@export var drop_heal_item_on_death: bool ## determines if the enemy should drop the healing item upon being destroyed
@export var boom_speed_mult: float = 1.5 ## the multiplier to apply to the explosion effect's speed
@export var sceneboom: PackedScene ## explosion effect scene
@export var sceneheal: PackedScene ## the healing item scene to be dropped

var speed = 250

func _process(delta):
	position.y += speed * delta

func initialize(startposx: float, startposy: float):
	position.x = startposx
	position.y = startposy

func take_damage(dmg: int = 1):
	health -= dmg
	if health <= 0:
		explode()
	else:
		take_knockback()

func take_knockback():
	var delta = get_process_delta_time() 
	$KnockTimer.start()
	set_process(false)
	while $KnockTimer.time_left > 0:
		if !get_tree().paused:
			position.y -= 200 * delta
		await get_tree().create_timer(0.01 * delta).timeout

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player") and bounce_on_hit:
		take_knockback()

func _on_knock_timer_timeout():
	set_process(true)

func explode():
	var boom = sceneboom.instantiate()
	boom.position = position
	add_sibling(boom)
	boom.act(boom_speed_mult)
	if drop_heal_item_on_death and playervars.health < 3:
		# if the player's health is not full, roll a chance to drop a healing item
		if randf_range(0, 12) <= 4:
			var healitem = sceneheal.instantiate()
			healitem.position = position
			call_deferred("add_sibling", healitem)
