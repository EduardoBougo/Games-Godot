extends Area2D

@export var scene: String

func _ready() -> void:
	Global.coins = 0
	Global.vidas = 3
	Global.points = 0


func _on_body_entered(body: Node2D) -> void:
	print("aaaa")
	if body.is_in_group("player"):
		print("bbbb")
		get_tree().change_scene_to_file(scene)
