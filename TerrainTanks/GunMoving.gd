extends MeshInstance3D

var target_rotation: float = 0
var rotation_direction: int = 0
var rotation_speed: float = 1
var rotated: bool = true

var target_position: Vector3 = Vector3.ZERO

# rotates the turret and gun
func _process(delta) -> void:
	print("new")
	# get angle to rotate according to global values
	print(target_position)
	print(global_position)
	print(global_rotation)
	var direction = target_position - global_position
	print(direction)
	var angle_to: float = global_transform.basis.y.signed_angle_to(direction, Vector3.FORWARD)
	print(angle_to)
	angle_to = global_transform.basis.y.signed_angle_to(direction, Vector3.BACK)
	print(angle_to)
	angle_to = global_transform.basis.y.signed_angle_to(direction, Vector3.LEFT)
	print(angle_to)
	angle_to = global_transform.basis.y.signed_angle_to(direction, Vector3.RIGHT)
	print(angle_to)
	angle_to = global_transform.basis.y.signed_angle_to(direction, Vector3.UP)
	print(angle_to)
	angle_to = global_transform.basis.y.signed_angle_to(direction, Vector3.DOWN)
	print(angle_to)
	#rotate(Vector3.FORWARD, sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))

# rotates the turret and gun
#func _process(delta) -> void:
#	if not rotated:
#		var new_rotation: float = rotation.z + (rotation_speed * rotation_direction * delta)
#
#		if rotation_direction == 1 and new_rotation > target_rotation:
#			new_rotation = target_rotation
#			rotated = true
#		elif rotation_direction == -1 and new_rotation < target_rotation:
#			new_rotation = target_rotation
#			rotated = true
#		rotation.z = new_rotation
#
	raycast_target()

const RAY_LENGTH = 100.0
# raycasts for target marker
func raycast_target() -> void:
	var from: Vector3 = global_position
	var to: Vector3 = from + Vector3(cos(global_rotation.y) * RAY_LENGTH, sin(global_rotation.z) * RAY_LENGTH, -sin(global_rotation.y) * RAY_LENGTH)
	
	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	if result:
		set_marker_location(result.position)
	else:
		set_marker_location(to)

func give_marker(position_value: Vector3) -> void:
	print(position_value)
	target_position = Vector3(position_value.x, position_value.y, global_position.z)

# sets marker location
func set_marker_location(pos: Vector3) -> void:
	$"../Marker".global_position = pos

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
