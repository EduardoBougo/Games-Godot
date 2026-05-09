extends Area2D

@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _on_body_entered(body: Node2D ) -> void:
	if body.name == "Player":
		timer.start()
		
		if body.has_method("killzone"):
			body.killzone()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
