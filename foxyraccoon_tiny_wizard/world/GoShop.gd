extends QuiverInteractMechanic



func _on_area_2d_body_entered(body):
	if body is QuiverCharacter:
		interact(body)


func _on_area_2d_body_exited(body):
	if body is QuiverCharacter:
		interact(body)
