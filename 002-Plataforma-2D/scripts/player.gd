extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

var esta_morto = false

func _physics_process(delta: float) -> void:
	# Adicionando Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if esta_morto == true:
		velocity.x = 0 # Para o movimento
		move_and_slide() # Aplica a gravidade para ele cair
		return
	
	# Ação de Pular
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obter direção do movimento e controle do movimento/desacelerar a ação
	var direction := Input.get_axis("Esquerda", "Direita")
	if direction:
		player_sprite.play("run")
		velocity.x = direction * SPEED
		player_sprite.scale.x = direction * 1.1
	else:
		player_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func killzone():
	esta_morto = true
	
	player_sprite.play("death") 
	
	# Desativa colisão do player 
	collision_layer = 0
	collision_mask = 1
