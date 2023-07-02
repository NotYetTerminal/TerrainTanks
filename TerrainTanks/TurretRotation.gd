extends MeshInstance3D

@export var turret_speed: float = 100
@export var gun_speed: float = 50
var gun: MeshInstance3D

func _ready() -> void:
	gun = get_child(0)

func _process(delta) -> void:
	var direction: int = 0
	var elevation: float = 0
	
	if Input.is_action_pressed("turret_left"):
		direction += 1
	elif Input.is_action_pressed("turret_right"):
		direction -= 1
	rotation_degrees.y += direction * turret_speed * delta
	
	if Input.is_action_pressed("turret_up"):
		if gun.rotation_degrees.z < 20:
			elevation += 1
	elif Input.is_action_pressed("turret_down"):
		if gun.rotation_degrees.z > -5:
			elevation -= 1
	gun.rotation_degrees.z += elevation * gun_speed * delta
