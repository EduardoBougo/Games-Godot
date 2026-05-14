extends CharacterBody2D
class_name Player

@onready var hud: CanvasLayer = $"../HUD"

signal player_died

# --- Exports --- 
@export var bullet_scene : PackedScene

# --- Variaveis de disparo --- 
var can_shoot : bool = true
var shoot_cooldown : float = 0.6

# --- Variaveis de movimento --- 
var move_speed := 1300.0
var move_direction := Vector2.ZERO

# --- Variaveis de Vida ---
@export var max_health := 100
var current_health := max_health

# --- Variaveis de Knockback ---
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 800.0
var knockback_force : float = 250.0

# --- Tipos de Power Ups ---
var powerups = {
	"speed_shot" : false,
	"mega_shot" : false,
	"freeze" : false
}

# --- Variaveis de Limite de Mapa --- 
var margin: int = 50
@onready var viewport_size := get_viewport_rect().size

# --- Função Padrão do Objeto (Inicio) --- 
func _ready() -> void:
	Global.player = self

func _process(delta: float) -> void:
	global_position.x = clamp(global_position.x, margin, viewport_size.x - margin)
	global_position.y = clamp(global_position.y, margin, viewport_size.y - margin)

# --- Função Padrão do Objeto (Toda a execução) --- 
func _physics_process(delta: float) -> void:
	if knockback_velocity.length() > 1: # Caso tome Knockback
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		# Movimentação
		move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = move_direction * move_speed
	
	# Disparo
	var mouse_direction = get_global_mouse_position() - global_position
	if Input.is_action_pressed("shoot")and can_shoot:
		_shoot(mouse_direction)
	
	move_and_slide()

# --- Função de Disparo --- 
func _shoot(direction):
	can_shoot = false
	
	var bullet_instance = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	
	# --- Mega Shot ---
	if powerups["mega_shot"]:
		bullet_instance.scale *= 2
	
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func apply_power_up(type: String):
	match type:
		"speed_shot":
			powerups["speed_shot"] = true
			shoot_cooldown = 0.01
			await  get_tree().create_timer(3.0).timeout
			shoot_cooldown = 0.3
			powerups["speed_shot"] = false
		
		"mega_shot":
			powerups["mega_shot"] = true
			await  get_tree().create_timer(3.0).timeout
			powerups["mega_shot"] = false
		
		"freeze":
			powerups["freeze"] = true
			Global.freeze.emit(5.0)
			await  get_tree().create_timer(3.0).timeout
			powerups["freeze"] = false


func take_damage(amount: float, source_position: Vector2):
	current_health -= amount
	current_health = clamp(current_health, 0 , max_health)
	
	# [Knockback Recebido]
	var knockback_direction = (position - source_position).normalized()
	apply_knockback(knockback_direction * knockback_force)
	
	hud.atualizar_barra_vida(current_health, max_health)

# --- Função para Receber Knockback--- 
func apply_knockback(force: Vector2):
	knockback_velocity = force

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if current_health > 0:
			take_damage(1, body.global_position) 
		else:
			current_health = 0
			player_died.emit()
