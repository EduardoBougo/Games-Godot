extends Area2D

# Cria uma caixa de seleção no Inspetor para diferenciar buracos de inimigos (Morte Instantanea)
@export var morte_instantanea: bool = false 

@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		# Buraco/Void (Ignora as 3 vidas e mata hitkill)
		if morte_instantanea == true:
			timer.start()
			if body.has_method("killzone"):
				body.killzone()
				
		# Inimigo/Slime (Tira só 1 de vida)
		else:
			if body.has_method("tomar_dano"):
				# Puxa o resultado boleano (True se a vida zerou, False se sobreviveu)
				var morreu = body.tomar_dano() 
				
				# Ativa o timer de reiniciar a fase se as vidas acabaram (Morrer)
				if morreu == true:
					timer.start()

func _on_timer_timeout() -> void:
	Global.vidas = 3 # Reseta as vidas para o próximo round
	Global.coins = 0 # Reseta as moedas para o próximo round
	Global.points = 0 # Reseta os pontos para o próximo round
	get_tree().reload_current_scene()
