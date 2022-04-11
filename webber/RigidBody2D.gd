extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var web_speed = 800
var active_web:Web
var web_shot = preload("res://web_shot/Web.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		if is_instance_valid(active_web):
			active_web.destroy_web()
		var mouse_loc = get_global_mouse_position()
		var web = web_shot.instance()
		web.target = mouse_loc
		web.speed = web_speed
		active_web = web
		add_child(web)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
