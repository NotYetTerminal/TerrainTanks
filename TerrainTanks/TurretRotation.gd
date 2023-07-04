extends MeshInstance3D

var rotation_speed: float = 0.5
var target_position: Vector3 = Vector3.ZERO

# rotates the turret and gun
func _process(delta) -> void:
	# get angle to rotate according to global values
	var angle_to: float = global_transform.basis.x.signed_angle_to(target_position - global_position, Vector3.UP)
	rotate(Vector3.UP, sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))

func give_marker(position_value: Vector3) -> void:
	target_position = Vector3(position_value.x, global_position.y, position_value.z)

