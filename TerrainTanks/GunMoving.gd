extends MeshInstance3D

var target_rotation: float = 0
var rotation_direction: int = 0
var rotation_speed: float = 1
var rotated: bool = true

var target_position: Vector3 = Vector3.ZERO

# rotates the turret and gun
func _process(delta) -> void:
	# get angle to rotate according to global values
	var distance: float = Vector2(global_position.x, global_position.z).distance_to(Vector2(target_position.x, target_position.z))
	var direction = Vector3(distance, target_position.y - global_position.y, 0)
	var angle_to: float = transform.basis.x.signed_angle_to(direction, Vector3.FORWARD)
	#rotate(Vector3.FORWARD, sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))
	if Input.is_action_pressed("turret_up"):
		rotation.z += delta * rotation_speed
	if Input.is_action_pressed("turret_down"):
		rotation.z -= delta * rotation_speed

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
	print(global_rotation.x)
	var to: Vector3 = from + Vector3(cos(global_rotation.z) * cos(global_rotation.y) * RAY_LENGTH,
									sin(global_rotation.z) * RAY_LENGTH,
									cos(global_rotation.x) * -sin(global_rotation.y) * RAY_LENGTH)
	
	#var to: Vector3 = from + Vector3(cos(global_rotation.y) * RAY_LENGTH, sin(global_rotation.z) * RAY_LENGTH, -sin(global_rotation.y) * RAY_LENGTH)
	
	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	if result:
		set_marker_location(result.position)
	else:
		set_marker_location(to)

func give_marker(position_value: Vector3) -> void:
	target_position = position_value

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
