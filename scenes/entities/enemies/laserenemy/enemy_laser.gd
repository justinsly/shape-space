extends Enemy

signal foo
var look := false
var playerpos: Vector2
@onready var player = get_tree().get_first_node_in_group("player")
@onready var component_laser: ComponentLaser = $ComponentLaser

# tween doesnt sound like a real word anymore
func _on_initialized() -> void:
	await ready
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y + randi_range(44, 300), 0.7)
	tween.tween_property(self, "look", true, 0) # lock into player
	tween.tween_callback(component_laser.startcharge)
	tween.tween_await(foo).set_timeout(1.6)
	tween.tween_property(self, "look", false, 0) # stop looking
	tween.tween_await(foo).set_timeout(2.65)
	tween.tween_property(self, "rotation", 0, 0.5)
	tween.tween_property(self, "position:y", -90, 0.8)
	tween.tween_callback(queue_free)

func _process(_delta: float) -> void:
	if player:
		playerpos = player.global_position
		if look:
			look_at(playerpos)
			rotate(deg_to_rad(-90))
