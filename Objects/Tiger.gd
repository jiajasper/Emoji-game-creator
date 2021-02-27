extends KinematicBody2D

onready var player = get_node("/root/main/Level/Fox")

var direction = 0

var start_pos = Vector2(0,0)
var velocity = Vector2()
var init = false

var floor_normal = Vector2(0,-1)

export (int) var speed_x = 100
export (int) var speed_y = 0
export (int) var GRAVITY = 5000
export (int) var JUMP_FORCE = 0

var elapsed_seconds = 0
export (int) var wait_seconds = 2
	
func _ready():
	set_process(true)
	set_physics_process(true) 
	pass

	
func _process(delta):
	
	elapsed_seconds += delta
	  
	if player.position.x > position.x and elapsed_seconds > wait_seconds:
		direction = 1
		speed_x = speed_x
		elapsed_seconds = 0

	if player.position.x < position.x and elapsed_seconds > wait_seconds:
		direction = -1
		speed_x = speed_x
		elapsed_seconds = 0



func _physics_process(delta):
	if init == false:
		start_pos = global_position
		init = true 
	if Global.playing == true:
		speed_x = speed_x
		speed_y += GRAVITY * delta
		
		# MOVEMENT VELOCITY CALCULATION
		velocity.x = speed_x * direction
		velocity.y = speed_y * delta 
		
		# MOVEMENT VELOCITY EXECUTE
		velocity = move_and_slide(velocity,floor_normal)
	else:
		global_position = start_pos	
	pass
