extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Adicionando Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Ação de Pular
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obter direção do movimento e controle do movimento/desacelerar a ação
	var direction := Input.get_axis("Esquerda", "Direita")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
