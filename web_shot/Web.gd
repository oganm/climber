extends Node2D
class_name Web

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var origin = Vector2(0,0)
var current = Vector2(0,0)
var speed = 1
var target = Vector2(0,0)
var stuck = false
var sticking_point:Vector2
var lifetime = 5
var sticktime = 2
var time = 0
var web_impulse = 5
var stuck_object:StaticBody2D

func _ready():
	z_index = -1
	$Line2D.points = PoolVector2Array([Vector2(0,0),Vector2(0,0)])




func translate_direction():
	pass


func _physics_process(delta):
	if not stuck:
		var direction = to_local(target).normalized()
		current = direction*time*speed
		$Line2D.points[1] = current
		$Tip.position = current	
		time += delta
		if time > lifetime:
			destroy_web()
	else:
		var local_sticking_point = to_local(stuck_object.to_global(sticking_point))
		$Line2D.points[1] = local_sticking_point
		$Tip.position = local_sticking_point
		var parent:RigidBody2D = get_parent()
		parent.apply_central_impulse(
			(to_global($Line2D.points[1]) - to_global($Line2D.points[0])).normalized()*web_impulse
			)
		time += delta
		if time > sticktime:
			destroy_web()


func _on_Tip_body_entered(body):
	stuck = true
	stuck_object = body
	# get sticking point on the object
	sticking_point = stuck_object.to_local(to_global(current))
	time = 0

func destroy_web():
	queue_free()
