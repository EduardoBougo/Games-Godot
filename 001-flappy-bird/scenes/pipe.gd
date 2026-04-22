extends Area2D

# Sinal que os script emitira quando um corpocolidir com ele
signal hit

const SCROLL_SPEED = -150

func _process(delta):
	position.x += SCROLL_SPEED * delta
	if position.x < -100:
		queue_free()

func _on_body_entered(_body):
	# Quando qualquer corpo entrar na area, emite o sinal "hit"
	hit.emit() 


func _on_hit() -> void:
	pass # Replace with function body.
