extends Node

@onready var pipe_scene = preload("res://scenes/pipe.tscn")
@onready var player = $Player
@onready var over_label = $CanvasLayer/OverLabel
@onready var score_label = $CanvasLayer/ScoreLabel

# Intervalo de altura aleatoria para os canos
var y_spawn_range = [175, 390]
var is_game_over = false

# Pontuação
var score = 0

func _ready():
	# Inicia o jogo
	new_game()

func new_game():
	# Inicia o passaro
	player.start()
	
	# Inicia o timer para gerar canos
	$PipeSpawner.start()

func _on_pipe_spawner_timeout():
	# Essa função é chamada toda vez que o Timer terminar sua contagem
	
	# Cria uma nova instancia da cena do cano
	var pipe_instance = pipe_scene.instantiate()
	
	# Defina uma posição y aleatoria
	var random_y = randf_range(y_spawn_range[0], y_spawn_range[1])
	
	pipe_instance.position = Vector2(get_viewport().get_visible_rect().size.x + 100, random_y)
	
	# Conecta os sinais do cano recem-criado
	pipe_instance.hit.connect(game_over)
	
	# Conecta os sinais de pontuação 
	var score_area = pipe_instance.get_node("ScoreArea")
	score_area.body_entered.connect(_on_score)
	
	# Adiciona a instancia do cano comop filha do nó Main
	add_child(pipe_instance)

func _on_score(_body):
	score += 1
	score_label.text = str(score)


func _unhandled_input(event):
	if is_game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func game_over():
	over_label.visible = true
	
	# Para o timer de geração de canos
	$PipeSpawner.stop()
	
	# para todos os canos da tela
	get_tree().call_group("pipes", "set_process", false)
	
	# Para o jogador
	player. set_physics_process(false)
	
	is_game_over = true

func _on_level_limits_body_entered(_body):
	game_over()
