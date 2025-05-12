extends Sprite2D

var transparency: float = 1.0
var fadeoff = false

# NOTE: the only intended way this scene is meant to be used is to add it into a scene through code when needed, and then calling expandboom() the moment they are added
func _process(delta):
	if fadeoff:
		transparency -= 0.001
		modulate = Color(1, 1, 1, transparency)
		await get_tree().create_timer(0.01 * delta).timeout
	
	if transparency <= 0:
		print("bye")
		queue_free()

func expandboom(newscale: Vector2):
	print("expand boom")
	while fadeoff == false:
		print("b")
		await get_tree().create_timer(0.01).timeout
		scale += Vector2(0.1, 0.1)
		if scale >= newscale:
			print("bye boom")
			set_scale(newscale)
			fadeoff = true
