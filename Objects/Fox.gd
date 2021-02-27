extends KinematicBody2D

var input_direction = 0
var direction = 0
 
var speed_x = 0
var speed_y = 0
var start_pos = Vector2(0,0)
var velocity = Vector2()
var init = false

var floor_normal = Vector2(0,-1)

export (int) var GRAVITY = 5000
export (int) var JUMP_FORCE = 5000
export (int) var MAX_SPEED = 1000
export (int) var ACCELERATION = 3000
export (int) var DECELERATION = 5000

func _ready():
	set_physics_process(true)
	set_process_input(true)
 
func _input(event):
	if event.is_action_pressed("ui_up") and is_on_floor():
		speed_y = - JUMP_FORCE
	pass
	

func _physics_process(delta):
	# THESE ARE FOR LEVEL EDITOR TOOL
	if init == false:
		start_pos = global_position
		init = true 
		
	if Global.playing == true:
		# INPUT 
		if input_direction:
			direction = input_direction
	 
		if Input.is_action_pressed("ui_left"):
			input_direction = -1
		elif Input.is_action_pressed("ui_right"):
			input_direction = 1
		else:
			input_direction = 0

		# MOVEMENT DIRECTION AND SPEED CALCULATION
		if input_direction == - direction:
			speed_x /= 3
		if input_direction:
			speed_x += ACCELERATION * delta
		else:
			speed_x -= DECELERATION * delta
			
		speed_x = clamp(speed_x, 0, MAX_SPEED)
		speed_y += GRAVITY * delta
		
		# MOVEMENT VELOCITY CALCULATION
		velocity.x = speed_x * delta * direction
		velocity.y = speed_y * delta 
		
		# MOVEMENT VELOCITY EXECUTE
		velocity = move_and_slide(velocity,floor_normal)
		
	else:
		# RETURN TO START POSITION OF THE CURRENT LEVEL DESIGN 
		global_position = start_pos	
	pass

