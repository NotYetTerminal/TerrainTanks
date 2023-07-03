extends MeshInstance3D

var target_rotation: float = 0
var rotation_direction: int = 0
var rotation_speed: float = 1

var difference_rotation: float = 0
var rotated_amount: float = 0

var target_position: Vector2 = Vector2.ZERO

var angle_y: float = 0
var turn_rate: float = 0
var target_turn_rate: float = 0
var previous_turn_rate: float = 0

# rotates the turret and gun
func _process(delta) -> void:
	angle_y = global_rotation.y
#	print(global_position)
#	var angle_to_player = Vector2(global_position.x, global_position.z).direction_to(target_position).angle()
#	print(angle_to_player)
#	rotation.y = move_toward(rotation.y, angle_to_player, delta)
	print("new")

	# get target position
	# get rotation to target
	var target_angle = Vector2.RIGHT.angle_to(target_position)
	# get delta angle between rotation and rotation to target
	target_angle = target_angle - angle_y
	target_angle = fposmod(target_angle + PI, PI * 2) - PI
	print(target_angle)

	var sign = sign(target_angle)
	target_angle = abs(target_angle)
	# lerp from 0 to 1 according to speed and angle
	target_turn_rate = lerp(0.0, 1.0, target_angle / (rotation_speed * delta)) * sign

	# adjust turn rate according to delta
	turn_rate = move_toward(turn_rate, target_turn_rate, delta)
	
	# change y rotation
	#angle_y += rotation_speed * turn_rate * delta
	#rotation.y = angle_y
	
#	if rotated_amount < difference_rotation:
#		var rotate_value: float = (rotation_speed * rotation_direction * delta)
#		rotated_amount += rotate_value
#		rotation.y = wrapf(rotation.y + rotate_value, -3.14, 3.14)

func give_marker(position_value: Vector3) -> void:
	target_position = Vector2(position_value.x, -position_value.z)

# sets a new rotation target
func set_new_rotation(target: float) -> void:
	# if rotation is new
	difference_rotation = abs(target - rotation.y)
	if difference_rotation > 0.01:
		target_rotation = target
		var direction = 0
		# if rotation is 0
		if target_rotation == 0:
			if rotation.y > 0:
				direction = -1
			else:
				direction = 1
		elif rotation.y == 0:
			if target_rotation > 0:
				direction = 1
			else:
				direction = -1
		else:
			# if on opposite signs
			if target_rotation > 0 and rotation.y < 0:
				if target_rotation - rotation.y > 3.14:
					direction = -1
				else:
					direction = 1
				pass
			elif target_rotation < 0 and rotation.y > 0:
				if rotation.y - target_rotation > 3.14:
					direction = 1
				else:
					direction = -1
			else:
				# if same signs
				if target_rotation > rotation.y:
					direction = 1
				else:
					direction = -1
		rotation_direction = direction
		rotated_amount = 0

