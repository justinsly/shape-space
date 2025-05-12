extends Area2D

@export var sceneboom: PackedScene
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
		print("i touched player")
		var delta = get_process_delta_time() 
		$KnockTimer.start()
		set_process(false)
		while $KnockTimer.time_left > 0:
			position.y -= 200 * delta
			await get_tree().create_timer(0.01 * delta).timeout

func _on_knock_timer_timeout():
	set_process(true)

# FIXME: it works yet it doesnt work, the explosion does get instantiated as shown in the output, but it doesnt actually appear
func explode():
	var boom = sceneboom.instantiate()
	boom.global_position = global_position
	add_child(boom)
	boom.expandboom(Vector2(1.5, 1.5))
