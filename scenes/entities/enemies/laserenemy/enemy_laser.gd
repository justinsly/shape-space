extends Enemy

signal foo
var look := false
var playerpos: Vector2
@onready var raycast: ShapeCast2D = $ShapeCast2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var laserline: Line2D = $Line2D
@onready var warnline: Line2D = $warnline

# tween doesnt sound like a real word anymore
func _on_initialized() -> void:
	await ready
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y + randi_range(44, 300), 0.7)
	tween.tween_property(self, "look", true, 0) # lock into player
	tween.tween_property(warnline, "visible", true, 0)
	tween.tween_property(warnline, "width", 8, 1.5)
	tween.tween_property(self, "look", false, 0) # stop looking
	tween.tween_await(foo).set_timeout(0.3)
	tween.tween_property(raycast, "enabled", true, 0) # shoot
	tween.tween_property(warnline, "visible", false, 0)
	tween.tween_property(laserline, "visible", true, 0)
	tween.tween_await(foo).set_timeout(1.5)
	tween.tween_property(raycast, "enabled", false, 0) # stop shooting
	tween.tween_property(laserline, "width", 0.01, 0.4)
	tween.tween_property(laserline, "visible", false, 0)
	tween.tween_await(foo).set_timeout(0.5)
	tween.tween_property(self, "rotation", 0, 0.5)
	tween.tween_property(self, "position:y", -90, 0.8)
	tween.tween_callback(queue_free)

func _process(_delta: float) -> void:
	if player:
		playerpos = player.global_position
		if look:
			look_at(playerpos)
			rotate(deg_to_rad(-90))
	if raycast.is_colliding():
		var collidingthing = raycast.get_collider(0)
		if collidingthing.is_in_group("player") && collidingthing.has_method("take_damage"):
			collidingthing.take_damage()
