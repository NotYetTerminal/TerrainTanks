extends SpringArm3D

var mouse_sensitivity: float = 0.1

func _ready() -> void:
	# sets rotation indepentdent of parent
	set_as_top_level(true)
	# locks mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# raycasts for turret
const RAY_LENGTH = 1000.0
func _process(_delta) -> void:
	var camera3d = $Camera3D
	var middle: Vector2 = Vector2(576, 324);
	var from: Vector3 = camera3d.project_ray_origin(middle)
	var to: Vector3 = from + camera3d.project_ray_normal(middle) * RAY_LENGTH
	
	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	if result:
		get_parent().calculate_rotation(result.position)
	else:
		get_parent().calculate_rotation(to)

# rotates the arm according to the mouse movement
func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 30)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)

