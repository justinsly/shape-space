extends Node2D
class_name ComponentLaser
## useful description describing this component
##
## TODO: actually write this description

signal startedcharging ## emitted when [param startcharge] is executed
signal startedshooting ## emitted when [param shoot] is executed
@warning_ignore("unused_signal")
signal stoppedshooting ## emitted when the component finishes the shooting action

signal _s ## this signal is used as a placeholder and it should never be called
enum LayerMasks {
	DETECT_PLAYER, ## the raycast will detect and try to damage the player
	DETECT_ENEMIES, ## the raycast will detect enemies
	NO_CHANGES ## the raycast's collision mask will not be changed, use this if you want to set the collision masks however you want
}
@export_group("Nodes")
## the raycast node, can be either a [RayCast2D] or a [ShapeCast2D]. it is recommended that the node's [param Enabled] property is disabled
@export var raycast: Node2D:
	set(value):
		raycast = value
		assert(raycast.is_class("RayCast2D") || raycast.is_class("ShapeCast2D"), "expected 'RayCast2D' or 'ShapeCast2D' for the raycast property but got assigned %s instead!!!!!!!" % raycast.get_class())
@export var laser_line: Line2D ## the [Line2D] that represents the laser
@export var warn_line: Line2D ## the [Line2D] that represents the warning indicator. optional
@export_group("Properties")
@export var damage := 1 ## how much damage the laser should deal
@export var should_do_damage := true ## if the laser should deal damage to any entity detected, disable if you want to perform custom operations on detection
@export var entities_to_hit: LayerMasks ## what collision layer the raycast node should detect
@export var warnLine_finalWidth := 8 ## the width of the warn line right before the laser fires
@export var charge_speed := 1.8 ## how long should it take for the laser to fire (the true speed would be [param charge_speed] + 0.3
@export var linger_time := 1.5 ## how long should the laser stay before disappearing
@export_group("Less important stuff")
@export var disable_raycast_on_ready := true ## if you want the raycast to always be enabled then you should disable this
@export var hide_laser_line_on_ready := true ## same as above but for the laser line
var _shoottween: Tween
var charging := false
var _oglaserlinewidth: float
var _ogwarnlinewidth: float

func _ready() -> void:
	if hide_laser_line_on_ready:
		laser_line.visible = false
	if disable_raycast_on_ready:
		raycast.enabled = false
	_oglaserlinewidth = laser_line.width
	_ogwarnlinewidth = warn_line.width
	
	match entities_to_hit:
		0:
			raycast.set_collision_mask(2)
		1:
			raycast.set_collision_mask(4)
		2:
			pass

func startcharge():
	if charging:
		push_warning("startcharge was triggered but we're already charging!!! trigger ignored")
		return
	charging = true
	startedcharging.emit()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	if warn_line:
		tween.tween_property(warn_line, "visible", true, 0)
		tween.tween_property(warn_line, "width", warnLine_finalWidth, charge_speed)
	else:
		tween.tween_await(_s).set_timeout(charge_speed)
	tween.tween_await(_s).set_timeout(0.3)
	tween.tween_callback(shoot)
	tween.tween_property(self, "charging", false, 0)

func shoot():
	startedshooting.emit()
	if _shoottween:
		_shoottween.kill()
	_shoottween = create_tween()
	_shoottween.set_ease(Tween.EASE_IN)
	_shoottween.set_trans(Tween.TRANS_SINE)
	_shoottween.tween_property(raycast, "enabled", true, 0)
	if warn_line:
		_shoottween.tween_property(warn_line, "visible", false, 0)
		_shoottween.tween_property(warn_line, "width", _ogwarnlinewidth, 0)
	if laser_line:
		_shoottween.tween_property(laser_line, "visible", true, 0)
	_shoottween.tween_await(_s).set_timeout(linger_time)
	_shoottween.tween_property(raycast, "enabled", false, 0)
	_shoottween.tween_property(laser_line, "width", 0.01, 0.4)
	_shoottween.tween_property(laser_line, "visible", false, 0)
	_shoottween.tween_property(laser_line, "width", _oglaserlinewidth, 0)
	_shoottween.tween_callback(emit_signal.bind("stoppedshooting"))
	

func _physics_process(_delta: float) -> void:
	if should_do_damage:
		if raycast.is_colliding():
			var collidingthing = raycast.get_collider(0) if raycast.is_class("ShapeCast2D") else raycast.get_collider()
			if collidingthing.has_method("take_damage"):
				collidingthing.take_damage(damage)
