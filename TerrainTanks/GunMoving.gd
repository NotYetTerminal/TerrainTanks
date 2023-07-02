extends MeshInstance3D

var target_rotation: float = 0
var rotation_direction: int = 0
var rotation_speed: float = 1
var rotated: bool = true

# rotates the turret and gun
func _process(delta) -> void:
	if not rotated:
		var new_rotation: float = rotation.z + (rotation_speed * rotation_direction * delta)
		
		if rotation_direction == 1 and new_rotation > target_rotation:
			new_rotation = target_rotation
			rotated = true
		elif rotation_direction == -1 and new_rotation < target_rotation:
			new_rotation = target_rotation
			rotated = true
		rotation.z = new_rotation

# sets a new rotation target
func set_new_rotation(target: float) -> void:
	# if rotation is new
	if target != rotation.z:
		target_rotation = target
		var direction = 0
		# if rotation is 0
		if target_rotation == 0:
			if rotation.z > 0:
				direction = -1
			else:
				direction = 1
		elif rotation.z == 0:
			if target_rotation > 0:
				direction = 1
			else:
				direction = -1
		else:
			# if on opposite signs
			if target_rotation > 0 and rotation.z < 0:
				direction = 1
			elif target_rotation < 0 and rotation.z > 0:
				direction = -1
			else:
				# if same signs
				if target_rotation > rotation.z:
					direction = 1
				else:
					direction = -1
		rotation_direction = direction
		rotated = false
