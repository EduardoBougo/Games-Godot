extends CharacterBody2D


const SPEED = 100.0
var direction = 1
var eliminado: bool = false


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cima: RayCast2D = $Cima


func _physics_process(delta: float) -> void:
	if eliminado == false:
		# Adicionando gravidade
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Movimento
		velocity.x = SPEED * direction
		animated_sprite_2d.play("idle")
		move_and_slide()
		
		# Colisao em Paredes
		if is_on_wall():
			inverter_direcao()
		
		if ray_cima.is_colliding():
			eliminado = true
			animated_sprite_2d.stop()
			animated_sprite_2d.play("dead")
	
	else:
		await get_tree().create_timer(2.0).timeout
		
		Global.points += 500
		
		queue_free()



func inverter_direcao():
	direction *= -1
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
