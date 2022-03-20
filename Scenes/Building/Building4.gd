extends Spatial



func _on_AreaDoor1_body_entered(body):
	if body.name == "Player":
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("door1_open")


func _on_AreaDoor1_body_exited(body):
	if body.name == "Player":
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("door1_close")


func _on_AreaDoor2_body_entered(body):
	if body.name == "Player":
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("door2_open")


func _on_AreaDoor2_body_exited(body):
	if body.name == "Player":
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("door2_close")
