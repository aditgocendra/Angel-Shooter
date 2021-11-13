extends KinematicBody

var shoot = false
var speed = 200
var direction : Vector3




	
	
func _physics_process(delta):
	if shoot:
		var col = move_and_collide(delta * direction * speed)
		
		if col:
			if col.collider:
				queue_free()
			
		
	
	

