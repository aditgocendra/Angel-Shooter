extends Spatial



func _on_AreaDoor_body_entered(body):
	if body.name == "Player":
		$Door/AnimationPlayer.play("door_open")


func _on_AreaDoor_body_exited(body):
	if body.name == "Player":
		$Door/AnimationPlayer.play("door_close")
