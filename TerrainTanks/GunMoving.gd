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

# sets marker location
func set_marker_location(pos: Vector3) -> void:
	$"../Marker".global_position = pos
	print("Marker: ", pos)

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
