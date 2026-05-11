extends Enemy

@export var spinstopper : PackedScene
@export var max_magicnum_value := 25 ## you normally shouldnt need to change this...
var magicnumber := randi_range(1, max_magicnum_value)
var spinning = false
var moving = false

func _on_initialized():
	await ready
	for scene in get_tree().get_nodes_in_group("spinstopper"):
		if !scene.has_meta("collisionID"):
			continue
		while scene.get_meta("collisionID") == magicnumber:
			magicnumber = randi_range(1, max_magicnum_value)
	if position.x < 512:
		dothespin(0)
	else:
		dothespin(1)

func dothespin(dir: int = 0):
	var spinstopspot = spinstopper.instantiate()
	spinstopspot.set_meta("collisionID", magicnumber)
	spinstopspot.position = Vector2(position)
	add_sibling(spinstopspot)
	activate_spinstopper(2, spinstopspot)
	if dir <= 0:
		rotation -= 0.8
	else:
		rotation += 0.8
	spinning = true
	
	if dir <= 0:
		while spinning:
			var delta = get_process_delta_time()
			if is_inside_tree():
				if get_tree().is_paused():
					await get_tree().create_timer(delta).timeout
					continue
			var movedir = Vector2.UP.rotated(rotation) * speed
			rotation -= PI * delta
			position += movedir * delta
			await get_tree().create_timer(delta).timeout
	else:
		while spinning:
			var delta = get_process_delta_time()
			if is_inside_tree():
				if get_tree().is_paused():
					await get_tree().create_timer(delta).timeout
					continue
			var movedir = Vector2.UP.rotated(rotation) * speed
			rotation += PI * delta
			position += movedir * delta
			if is_inside_tree():
				await get_tree().create_timer(delta).timeout

func _process(delta: float):
	if moving:
		position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func activate_spinstopper(delay: float, thenode):
	await get_tree().create_timer(delay).timeout
	thenode.set_collision_layer_value(6, true)
	thenode.monitorable = true
	

func _on_area_entered(area: Area2D):
	if area.has_meta("collisionID") && area.get_meta("collisionID") == magicnumber:
		print_verbose("trying to stop spinning")
		spinning = false
		moving = true
		rotation_degrees = 180.0

func _on_damage_taken(_dmg_amount, _oldhealth):
	if health <= 0:
		explode(false)
