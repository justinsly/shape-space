extends Enemy

func _on_initialized() -> void:
	$AnimationPlayer.play("descend")

func startshooting() -> void:
	pass
