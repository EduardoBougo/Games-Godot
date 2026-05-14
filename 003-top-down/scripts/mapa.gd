extends Node2D

@onready var hud: CanvasLayer = $HUD

@onready var player: Player = $Player

# --- Exports --- 
@export var enemy_scene : PackedScene
@export var spawn_margin := 200

# --- Inimigos Ativos ---
var active_enemeis: Array = []

# --- Tipos de Inimigos ---
var enemy_scenes: Dictionary = {
	"easy": preload("res://entities/enemy_easy.tscn"),
	"medium": preload("res://entities/enemy_medium.tscn"),
	"hard": preload("res://entities/enemy_hard.tscn")
}

# --- Tipos de Power Up ---
var powerup_scenes: Dictionary = {
	"speed_shot": preload("res://prefabs/power_up_speed_shot.tscn"),
	"mega_shot": preload("res://prefabs/power_up_mega_shot.tscn"),
	"freeze": preload("res://prefabs/power_up_freeze.tscn")
}


# --- Variaveis de Wave --- 
var current_wave := 1
var enemies_per_wave := 3
var time_between_enemies := 0.3
var time_between_waves := 1.0
var is_spawning := false


func _ready() -> void:
	Global.score = 0
	spawn_wave()
	hud.atualizar_barra_vida(player.max_health, player.max_health)
	Global.score_update.connect(update_score_label)
	
	player.player_died.connect(hud.game_over_screen)


# --- Função de Spawnar Inimigos --- 
func spawn_enemy():
	var enemy_scene = get_enemy_scene_for_wave(current_wave)
	
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = calculate_spawn_position()
	enemy.player = player
	
	active_enemeis.append(enemy)
	enemy.tree_exited.connect(on_enemy_exit.bind(enemy))

func get_enemy_scene_for_wave(wave: int) -> PackedScene:
	if wave < 3:
		return enemy_scenes["easy"]
	elif wave < 6:
		return enemy_scenes["medium"]
	else:
		return enemy_scenes["hard"]

func on_enemy_exit(enemy):
	if enemy in active_enemeis:
		active_enemeis.erase(enemy)
	
	if active_enemeis.is_empty():
		next_wave()

func next_wave():
	if !is_inside_tree():
		await ready
	
	await get_tree().create_timer(time_between_waves).timeout
	current_wave += 1
	enemies_per_wave += 1
	is_spawning = false
	spawn_wave()

func spawn_wave():	
	if is_spawning:
		return
	hud.atualizar_wave(current_wave)
	
	for i in enemies_per_wave:
		spawn_enemy()
		await  get_tree().create_timer(time_between_enemies).timeout
	
	
	



# --- Função de Calcular a posição de Spawn dos Inimigos --- 
func calculate_spawn_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size # Pega o tamanho da tela do Player
	var player_position = player.global_position # Pega a posição do Player
	
	# Calcula a disntancia de spawn 
	#[Distancia do Player até a margem da Camera + Margem de Spawn]
	var spawn_distance := ((screen_size.length() / 2) + spawn_margin)
	
	var angle := randf_range(0, TAU) # Calcula o ângulo
	
	# Calcula a posição de spawn
	# [Posição do player + (Um circulo de raio spawn_distance)]
	var spawn_position = player_position + Vector2.RIGHT.rotated(angle) * spawn_distance
	
	return spawn_position

# --- Timer para Chamar a Função de Spawn ---
func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

# --- Função para atualizar o Score ---
func update_score_label(score):
	hud.atualizar_score(score)


func random_spawn_powerup():
	if randf() > 0.2:
		return
	
	var powerup_index = randi() % 3
	var powerup
	
	if powerup_index == 0:
		powerup = powerup_scenes["speed_shot"].instantiate()
	elif powerup_index == 1:
		powerup = powerup_scenes["mega_shot"].instantiate()
	elif powerup_index == 2:
		powerup = powerup_scenes["freeze"].instantiate()
	
	if powerup:
		powerup.position = Vector2(randi_range(100, 600), randi_range(100, 600))
		add_child(powerup)



func _on_power_up_spawn_timer_timeout() -> void:
	random_spawn_powerup()
