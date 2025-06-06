extends CharacterBody2D

signal hit
signal dieded
# NOTE: i have no freaking idea on what am i doing but i didnt bother searching up a better method, so for now this signal handles the flickering during iframes
signal flickerframe
# the bullet scene
@export var scenebullet: PackedScene
# the explosion effect scene
@export var sceneboom: PackedScene
var speed = 550
# used for delays between shots
var canfire = true
# for invuln periods when player gets hit
var iframes = false
# for the player to know if its alive
var alive = true
# downward acceleration velocity for the death animation
var fall_accel = 400


func _physics_process(delta):
	var direction = Vector2.ZERO
	if alive:
		if Input.is_action_pressed("move_right"):
			direction.x = 1
		if Input.is_action_pressed("move_left"):
			direction.x = -1
		if Input.is_action_pressed("move_up"):
			direction.y = -1
		if Input.is_action_pressed("move_down"):
			direction.y = 1
		
		if Input.is_action_pressed("shoot"):
			if canfire:
				canfire = false
				var bullet = scenebullet.instantiate()
				bullet.position = position
				bullet.position.y -= 30
				get_parent().add_child(bullet)
				$FireTimer.start()
		
		
		if direction != Vector2.ZERO:
			# prevents the player from being faster by moving diagonally
			direction = direction.normalized()
		velocity = direction * speed
	else:
		$Sprite2D.rotate(PI * delta)
		velocity.y += fall_accel * delta
	move_and_slide()

func _on_fire_timer_timeout():
	canfire = true

#FIXME: if the player is inside an enemy when the iframes runs out, they wont be considered as "hit"
func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		#print("touched by enemy")
		if not iframes:
			iframes = true
			print("ow")
			$IframeTimer.start()
			playervars.health -= 1
			if playervars.health <= 0:
				playervars.health = 0
				dieded.emit()
				$CollisionShape2D.set_deferred("disabled", true)
				$Hitbox/CollisionShape2D.set_deferred("disabled", true)
				alive = false
				velocity.x = 0
				velocity.y = -350
			flickerframe.emit()
			hit.emit()


func _on_iframe_timer_timeout():
	#print("noframe")
	iframes = false


func _on_flickerframe():
	var delta = get_process_delta_time()
	while iframes:
		$Sprite2D.hide()
		await get_tree().create_timer(0.01 * delta).timeout
		$Sprite2D.show()
		await get_tree().create_timer(0.01 * delta).timeout


func _on_death_offscreen_notifier_screen_exited():
	if not alive:
		var boom = sceneboom.instantiate()
		boom.position = position
		if position.y > 648:
			boom.position.y -= 50
		add_sibling(boom)
		boom.expandboom(Vector2(5.0, 5.0))
		print("boom")
		queue_free()
