extends VehicleBody3D

var engine_force_value: float = 100
var turning_force_value: float = 50
var left_wheels: Array
var right_wheels: Array

var previous_angular_velocity: float = 0
var turn_values: Array = [0.785,0.785,0,-0.785,-0.785]
var go_and_turn_values: Array = [0.39,0.39,0,-0.39,-0.39]


func _ready() -> void:
	left_wheels = [$"Wheel L1", $"Wheel L2", $"Wheel L3", $"Wheel L4", $"Wheel L5"]
	right_wheels = [$"Wheel R1", $"Wheel R2", $"Wheel R3", $"Wheel R4", $"Wheel R5"]


func _process(_delta) -> void:
	var pos: Vector3 = position
	pos.y += 5
	$SpringArm3D.position = pos


func _physics_process(_delta) -> void:
	var straight: int = 0
	var turning: int = 0
	var braking: bool = false
	
	var left_engine_value: float = 0
	var right_engine_value: float = 0
	var braking_value: float = 0
	
	if Input.is_action_pressed("drive_forward"):
#		left_engine_value += engine_force_value
#		right_engine_value += engine_force_value
		straight += 1
	if Input.is_action_pressed("drive_backward"):
#		left_engine_value -= engine_force_value
#		right_engine_value -= engine_force_value
		straight -= 1
	
	if Input.is_action_pressed("turn_left"):
#		if left_engine_value == 0 && right_engine_value == 0:
#			left_engine_value -= turning_force_value
#			right_engine_value += turning_force_value
#		else:
#			left_engine_value -= turning_force_value
#			right_engine_value += turning_force_value
#			friction_slip_value = 5
#		var turn_values: Array = [0.785,0.785,0,-0.785,-0.785]
#		for index in range(5):
#			left_wheels[index].steering = turn_values[4-index]
#			right_wheels[index].steering = turn_values[index]

		#previous_angular_velocity += 0.1
		turning += 1
	elif Input.is_action_pressed("turn_right"):
#		if left_engine_value == 0 && right_engine_value == 0:
#			left_engine_value += turning_force_value
#			right_engine_value -= turning_force_value
#		else:
#			left_engine_value += turning_force_value
#			right_engine_value -= turning_force_value
#			friction_slip_value = 5
#		var turn_values: Array = [0.785,0.785,0,-0.785,-0.785]
#		for index in range(5):
#			left_wheels[index].steering = turn_values[4-index]
#			right_wheels[index].steering = turn_values[index]

		#previous_angular_velocity -= 0.1
		turning -= 1
	#else:
#		if previous_angular_velocity < 0:
#			previous_angular_velocity += 0.05
#		elif previous_angular_velocity > 0:
#			previous_angular_velocity -= 0.05

#		for index in range(5):
#			left_wheels[index].steering = 0
#			right_wheels[index].steering = 0
	
#	previous_angular_velocity = clamp(previous_angular_velocity, -1, 1)
#	angular_velocity.y = previous_angular_velocity
	
#	print(angular_velocity)
#	print(linear_velocity)
	
	if Input.is_action_pressed("brake"):
#		braking_value = 5
		braking = true
#	elif left_engine_value == 0 && right_engine_value == 0:
#		braking_value = 1
	
#	var index: int = 0
#	for wheel in left_wheels:
#		wheel.engine_force = left_engine_value
#		wheel.brake = braking_value
#
#		if Input.is_action_pressed("brake"):
#			if index > 1:
#				wheel.wheel_friction_slip = 1
#			else:
#				wheel.wheel_friction_slip = 10.5
#			index += 1
#		else:
#			wheel.wheel_friction_slip = 10.5
#
#	index = 0
#	for wheel in right_wheels:
#		wheel.engine_force = right_engine_value
#		wheel.brake = braking_value
#
#		if Input.is_action_pressed("brake"):
#			if index > 1:
#				wheel.wheel_friction_slip = 1
#			else:
#				wheel.wheel_friction_slip = 10.5
#			index += 1
#		else:
#			wheel.wheel_friction_slip = 10.5

	# braking
	if braking:
		for index in range(5):
			left_wheels[index].engine_force = 0
			right_wheels[index].engine_force = 0
			
			left_wheels[index].brake = 5
			right_wheels[index].brake = 5
	# going straight
	elif turning == 0 and straight != 0:
		var move_value: float = engine_force_value * straight
		for index in range(5):
			left_wheels[index].set_new_rotation(0)
			right_wheels[index].set_new_rotation(0)
			
			left_wheels[index].engine_force = move_value
			right_wheels[index].engine_force = move_value
			
			if straight == 1 and index >= 2 or straight == -1 and index <= 2:
				left_wheels[index].suspension_stiffness = 20
				right_wheels[index].suspension_stiffness = 20
			else:
				left_wheels[index].suspension_stiffness = 5
				right_wheels[index].suspension_stiffness = 5
			
			left_wheels[index].brake = 0
			right_wheels[index].brake = 0
			
	# turning on the spot
	elif straight == 0 and turning != 0:
		var move_value: float = turning_force_value * turning
		for index in range(5):
			left_wheels[index].set_new_rotation(turn_values[4-index])
			right_wheels[index].set_new_rotation(turn_values[index])
			
			left_wheels[index].engine_force = -move_value
			right_wheels[index].engine_force = move_value
			
			left_wheels[index].brake = 0
			right_wheels[index].brake = 0
			
	# turning and driving
	elif turning != 0 and straight != 0:
		var move_value: float = engine_force_value * straight * 2
		# changes the turning direction when going backwards
		var multiplier: int = calculate_direction()
		turning *= multiplier
		if turning == 1:
			for index in range(5):
				left_wheels[index].set_new_rotation(go_and_turn_values[index])
				right_wheels[index].set_new_rotation(go_and_turn_values[index])
				
				left_wheels[index].engine_force = move_value
				right_wheels[index].engine_force = move_value
				
				if straight == 1 and index >= 2 or straight == -1 and index <= 2:
					left_wheels[index].suspension_stiffness = 20
					right_wheels[index].suspension_stiffness = 20
				else:
					left_wheels[index].suspension_stiffness = 5
					right_wheels[index].suspension_stiffness = 5
				
				left_wheels[index].brake = 0
				right_wheels[index].brake = 0
		else:
			for index in range(5):
				left_wheels[index].set_new_rotation(go_and_turn_values[4-index])
				right_wheels[index].set_new_rotation(go_and_turn_values[4-index])
				
				left_wheels[index].engine_force = move_value
				right_wheels[index].engine_force = move_value
				
				if straight == 1 and index >= 2 or straight == -1 and index <= 2:
					left_wheels[index].suspension_stiffness = 20
					right_wheels[index].suspension_stiffness = 20
				else:
					left_wheels[index].suspension_stiffness = 5
					right_wheels[index].suspension_stiffness = 5
				
				left_wheels[index].brake = 0
				right_wheels[index].brake = 0
				
	# passive stopping
	else:
		for index in range(5):
			left_wheels[index].engine_force = 0
			right_wheels[index].engine_force = 0
			
			left_wheels[index].suspension_stiffness = 10
			right_wheels[index].suspension_stiffness = 10
			
			left_wheels[index].brake = 1
			right_wheels[index].brake = 1

# calculates the rotation and elevation for turret
func calculate_rotation(looking_position: Vector3) -> void:
	var rot = atan2(looking_position.z - position.z, looking_position.x - position.z)
	rot += rotation.y
	var elevation = atan2(looking_position.y - position.y, looking_position.x - position.z)
	elevation += rotation.z
	elevation = clamp(elevation, -0.08726646, 0.2617994)
	second raycast for actual target
	set_turret_and_gun(-rot, elevation)

# sets the direction turret and gun should face
func set_turret_and_gun(rotation_value: float, elevation: float) -> void:
	$Chassis/Head.set_new_rotation(rotation_value)
	$Chassis/Head/Gun.set_new_rotation(elevation)

# positive is forward
# negative is backwards
func calculate_direction() -> int:
	var x: float = cos(rotation.y) * linear_velocity.x
	var z: float = sin(rotation.y) * linear_velocity.z
	if x - z > 0:
		return 1
	else:
		return -1
	
