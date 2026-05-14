extends CanvasLayer

@onready var wave_label: Label = %wave_label
@onready var score_label: Label = %score_label
@onready var player_health_bar: ProgressBar = %player_health_bar

@onready var game_over: MarginContainer = $game_over
@onready var main_hud: MarginContainer = $main_hud

@onready var actual_score: Label = %actual_score
@onready var high_score: Label = %high_score


# --- Função para Atualizar o Label Wave ---
func atualizar_wave(numero_da_wave: int) -> void:
	wave_label.text = "WAVE: %d" % numero_da_wave

# --- Função para Atualizar o Label Score ---
func atualizar_score(score: int) -> void:
	score_label.text = "SCORE: %d" % score

# --- Função para Atualizar a Barra de Vida ---
func atualizar_barra_vida(health: float, max_health: float) -> void:
	player_health_bar.value = health
	player_health_bar.max_value = max_health

func game_over_screen():
	set_physics_process(false)
	get_tree().paused = true
	main_hud.hide()
	game_over.show()
	actual_score.text = "SCORE: " + str(Global.score)
	high_score.text = "HIGH SCORE: " + str(Global.highscore)


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/mapa.tscn")
