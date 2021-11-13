extends Spatial

var sensitivity = 0.1
var camrot_v

onready var spring_arm = $SpringArm
onready var camera = $SpringArm/Camera

onready var anim_tree = get_parent().get_node("AnimationTree")

var spring_length_default : float = 5.0 
var spring_length_ads : float = 2.5 

var camera_ads_rotation: float = 4
const ads_lerp = 15

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * sensitivity))
		spring_arm.rotate_x(deg2rad(-event.relative.y * sensitivity))
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg2rad(-35), deg2rad(45))
		
		if anim_tree["parameters/state/current"] == 1:
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg2rad(-15), deg2rad(25))
		
		
func _process(delta):
	if anim_tree["parameters/state/current"] == 1:
		spring_arm.spring_length = lerp(spring_arm.spring_length, spring_length_ads, ads_lerp * delta)
#		camera.rotation_degrees.y = lerp(camera.rotation_degrees.y, camera_ads_rotation, ads_lerp * delta)
		if spring_arm.rotation.x >= 0:
			anim_tree["parameters/aim_up_down/add_amount"] = -spring_arm.rotation.x / deg2rad(25)
		else:anim_tree["parameters/aim_up_down/add_amount"] = spring_arm.rotation.x / deg2rad(-15)
	else:
		spring_arm.spring_length = lerp(spring_arm.spring_length, spring_length_default, ads_lerp * delta)
#		camera.rotation_degrees.y = lerp(camera.rotation_degrees.y, 0, ads_lerp * delta)
		anim_tree["parameters/aim_up_down/add_amount"] = 0
	
	
