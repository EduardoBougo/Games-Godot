extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

# --- Exports --- 
@export var move_speed: float = 100.0
@export var health : int = 3
@export var score : int = 10

# --- Variaveis de movimento --- 
var direction : Vector2 = Vector2.ZERO
var player = null

# --- Variaveis de Knockback ---
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 800.0
var knockback_force : float = 250.0

# --- Variaveis de Estilizaão ---
var original_color := Color.WHITE 

var is_frozen : bool = false

# --- Função Padrão do Objeto (Inicio) --- 
func _ready() -> void:
	Global.freeze.connect(_on_freeze_enemies)
	player = Global.player
	original_color = sprite_2d.modulate

# --- Função Padrão do Objeto (Toda a execução) --- 
func _physics_process(delta: float) -> void:
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if knockback_velocity.length() > 1: # Caso tome Knockback
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		if player:
			direction = global_position.direction_to(player.global_position)
			velocity = direction * move_speed
		move_and_slide()

# --- Função para Receber Dano--- 
func take_damage(amount: int, source_position: Vector2):
	# [Vida - Dano Recebido]
	health -= amount
	
	# [Knockback Recebido]
	var knockback_direction = (position - source_position).normalized()
	apply_knockback(knockback_direction * knockback_force)
	
	# [Animação de Hit]
	hit_flash()
	
	# "Mata" o Inimigo quando sua vida chegar em zero
	if health <= 0:
		queue_free()
		Global.score += score

# --- Função para Receber Knockback--- 
func apply_knockback(force: Vector2):
	knockback_velocity = force

# --- Função Visual de Hit --- 
func hit_flash():
	sprite_2d.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = original_color

# --- Função de Freeze --- 
func _on_freeze_enemies(duration: float):
	is_frozen = true
	await get_tree().create_timer(duration).timeout
	is_frozen = false
