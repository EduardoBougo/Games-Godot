extends Area2D

# --- Exports --- 
@export var speed : float = 500

# --- Variavel de Direção --- 
var direction : Vector2 = Vector2.ZERO

# --- Função Padrão do Objeto (Toda a execução) --- 
func _process(delta: float) -> void:
	position += direction.rotated(rotation) * speed * delta # Executa a Trajetoria do Projetil

# --- Função para Setar a Direção do Disparo --- 
func set_direction(new_direction):
	direction = new_direction.normalized() 

# --- Função para "apagar" o Projetil ao Acertar Algo --- 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

# --- Função de Colisão do Projetil com Algo --- 
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1, global_position)
		queue_free()
