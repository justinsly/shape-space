extends Area2D

@export var sceneboom: PackedScene ## explosion effect scene
@export var sceneheal: PackedScene ## the healing item scene to be dropped
@export var bounce_on_hit: bool ## determines if the enemy should move backward a little bit upon hitting the player
@export var drop_heal_item_on_death: bool ## determines if the enemy should drop the healing item upon being destroyed

var speed = 250

func _process(delta):
	position.y += speed * delta

func initialize(startposx: float, startposy: float):
	position.x = startposx
	position.y = startposy


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		if bounce_on_hit:
			var delta = get_process_delta_time() 
			$KnockTimer.start()
			set_process(false)
			while $KnockTimer.time_left > 0:
				if !get_tree().paused:
					position.y -= 200 * delta
				await get_tree().create_timer(0.01 * delta).timeout

func _on_knock_timer_timeout():
	set_process(true)

func explode():
	var boom = sceneboom.instantiate()
	boom.position = position
	add_sibling(boom)
	boom.act(1.5)
	if drop_heal_item_on_death:
		# if the player's health is not full, roll a chance to drop a healing item
		if playervars.health < 3:
			if randf_range(0, 12) <= 4:
				var healitem = sceneheal.instantiate()
				healitem.position = position
				call_deferred("add_sibling", healitem)
