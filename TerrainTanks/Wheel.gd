extends VehicleWheel3D

var target_rotation: float = 0
var rotation_direction: int = 0
var rotation_speed: float = 10
var rotated: bool = true

# rotates the wheel
func _physics_process(delta) -> void:
	if not rotated:
		var new_steering: float = steering + (rotation_speed * rotation_direction * delta)
		
		if rotation_direction == 1 and new_steering > target_rotation:
			new_steering = target_rotation
			rotated = true
		elif rotation_direction == -1 and new_steering < target_rotation:
			new_steering = target_rotation
			rotated = true
		steering = new_steering

# sets a new rotation target
func set_new_rotation(target: float) -> void:
	# if rotation is new
	if target != steering:
		target_rotation = target
		var direction = 0
		# if rotation is 0
		if target_rotation == 0:
			if steering > 0:
				direction = -1
			else:
				direction = 1
		elif steering == 0:
			if target_rotation > 0:
				direction = 1
			else:
				direction = -1
		else:
			# if on opposite signs
			if target_rotation > 0 and steering < 0:
				direction = 1
			elif target_rotation < 0 and steering > 0:
				direction = -1
			else:
				# if same signs
				if target_rotation > steering:
					direction = 1
				else:
					direction = -1
		rotation_direction = direction
		rotated = false

