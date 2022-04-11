extends Node2D



var level_speed = 10
var speed_rate = 2
var rng = RandomNumberGenerator.new()
var spawn_cooldown = 4
var wall = preload("res://wall.tscn")
var score = 0
var high_score = 0
func _ready():
	var data = load_hs()
	if data.length() != 0:
		high_score = float(data)
		$UI/HighScore.text = 'High\n' + str(data)
	rng.randomize()
	var window = get_viewport().size
	$Killzone.position.y = window.y+window.y*0.5
	$SideWalls/Left.shape.extents.y = window.y*3
	$SideWalls/Right.shape.extents.y = window.y*3
	$SideWalls/Left.position.x = -16
	$SideWalls/Right.position.x = window.x+16

func _process(delta):
	level_speed += speed_rate*delta
	score += delta
	$UI/Score.text = str(round(score))
	
	var walls = get_tree().get_nodes_in_group('Wall')
	for x in walls:
		x.position.y += delta*level_speed
		x.constant_linear_velocity.y = level_speed
	
	spawn_cooldown -= delta
	if spawn_cooldown <= 0:
		spawn_cooldown = rng.randf_range(75/level_speed,150/level_speed)
		var spawn_count = rng.randi_range(0,3)
		for i in range(spawn_count):
			var x = rng.randf_range(0,get_viewport().size.x)
			var y = rng.randf_range(-64,-20)
			var new_wall = wall.instance()
			new_wall.position.x = x
			new_wall.position.y = y
			add_child(new_wall)
		
		


func _on_Killzone_body_entered(body):
	# Replace with function body.
	if body.name == 'Webber':
		if score > high_score:
			save_hs(round(score))
		get_tree().reload_current_scene()



func save_hs(content):
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
	file.store_string(str(content))
	file.close()

func load_hs():
	var file = File.new()
	file.open("user://save_game.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content


func _on_Killzone_area_entered(area):
	# i added an area to the wall objects
	# because their collisions were not detected
	# not sure why this happens
	area.get_parent().queue_free()

