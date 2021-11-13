extends KinematicBody

var speed
var default_speed = 12

var jump = 12

var accel_default = 6
var accel_air = 3
var accel

var gravity = 20
var gravity_vec : Vector3

var snap

var velocity : Vector3
var direction : Vector3
var movement : Vector3

var aim_strafe_dir : Vector3
var aim_strafe : Vector3

onready var camroot = $CamRoot
onready var spring_arm = $CamRoot/SpringArm
onready var body = $Hero
onready var anim_tree = $AnimationTree

#shoot
onready var spawn_bullet = $Hero/Armature/Skeleton/BoneAttachment/Weapon/SpawnPosBullet
onready var bullet = preload("res://Scenes/Object/Bullet/Bullet.tscn")
onready var shoot_timer = $ShootTimer
onready var aim_cast = $CamRoot/SpringArm/Camera/AimCast


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	speed = default_speed
	accel = accel_default
	anim_tree["parameters/state/current"] = 0
	
	
func _input(event):
	if event.is_action_pressed("toogle_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _physics_process(delta):
	direction = Vector3.ZERO
	
	var h_rot = spring_arm.global_transform.basis.get_euler().y
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_front")
	
	aim_strafe_dir = direction
	direction = Vector3(direction.x, 0, direction.z).rotated(Vector3.UP, h_rot).normalized()
	
	
	if direction.length() > 0 or Input.is_action_pressed("aim") == true:
		if anim_tree["parameters/state/current"] != 1: 
			body.rotation.y = lerp_angle(body.rotation.y, atan2(-direction.x, -direction.z), 7 * delta)
		else: body.rotation.y = lerp_angle(body.rotation.y, h_rot, 7 * delta)
		
		
	if is_on_floor():
		snap = -get_floor_normal()
		accel = accel_default + 2
		gravity_vec = Vector3.ZERO
		anim_tree["parameters/state/current"] = 0
	else:
		snap = Vector3.DOWN
		accel = accel_air
		gravity_vec += Vector3.DOWN * gravity * delta
		anim_tree["parameters/state/current"] = 2
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		
	if Input.is_action_pressed("aim") and is_on_floor():
		anim_tree["parameters/state/current"] = 1
		speed = 4
	else: speed = default_speed
	
	aim_strafe = lerp(aim_strafe, aim_strafe_dir, accel * delta)
	anim_tree["parameters/aim_strafe/blend_position"] = Vector2(aim_strafe.x, -aim_strafe.z)
	
	if Input.is_action_pressed("shoot") and anim_tree["parameters/state/current"] == 1 and shoot_timer.time_left == 0:
		var shoot_origin = spawn_bullet.global_transform.origin
		var shoot_target = aim_cast.get_collision_point()
		var shoot_direct = shoot_target - shoot_origin
		
		var b = bullet.instance()
		get_parent().add_child(b)
		
		b.global_transform.origin = shoot_origin
		b.direction = shoot_direct.normalized()
		b.rotation.y = body.rotation.y
		b.add_collision_exception_with(self)
		
		b.shoot = true
		shoot_timer.start()
		
		
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	movement = move_and_slide_with_snap(movement, snap, Vector3.UP)
	
	anim_tree["parameters/run/blend_position"] = Vector2(movement.x, movement.z)
	

