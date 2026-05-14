extends Area2D

@export var type : String = "speed_shot"

@onready var sprite_2d: Sprite2D = $Sprite2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_power_up(type)
		queue_free()
