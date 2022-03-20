extends Spatial



func _on_AreaFrontDoor_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("door_front_open")


func _on_AreaFrontDoor_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("door_front_close")


func _on_AreaBackDoor_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("door_back_open")


func _on_AreaBackDoor_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("door_back_close")
