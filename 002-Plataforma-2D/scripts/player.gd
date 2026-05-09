extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

var esta_morto = false
var invulneravel = false

func _physics_process(delta: float) -> void:
	# Adicionando Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Trava de morte: impede o personagem de andar
	if esta_morto == true:
		velocity.x = 0
		move_and_slide()
		return
	
	# Ação de Pular
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obter direção do movimento e controle
	var direction := Input.get_axis("Esquerda", "Direita")
	if direction:
		if invulneravel == false:
			player_sprite.play("run")
		
		velocity.x = direction * SPEED
		player_sprite.scale.x = direction * 1.1
	else:
		if invulneravel == false:
			player_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# --- SISTEMA DE DANO E MORTE ---

func tomar_dano() -> bool:
	# Ignora se já morreu ou se acabou de tomar outro hit
	if invulneravel == true or esta_morto == true:
		return false
	
	Global.vidas -= 1
	print("Vidas restantes: ", Global.vidas)
	
	player_sprite.play("hit")
	
	if Global.vidas <= 0:
		killzone()
		return true
	else:
		ficar_invulneravel()
		return false

func ficar_invulneravel():
	invulneravel = true
	player_sprite.play("hit")
	
	# Espera 1.5 segundos de cooldown
	await get_tree().create_timer(1.5).timeout
	
	invulneravel = false

func killzone():
	esta_morto = true
	player_sprite.play("death")
	collision_layer = 0
	collision_mask = 1
