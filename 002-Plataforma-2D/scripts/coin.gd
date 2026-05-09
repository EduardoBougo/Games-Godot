extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.coins += 1
		Global.points += 500
		queue_free()
