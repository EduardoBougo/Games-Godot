extends CanvasLayer

@onready var moedas_contador: Label = $Control/MarginContainer/itens/moedas_contador
@onready var vida_contador: Label = $Control/MarginContainer/itens/vida_contador
@onready var pontos_contador: Label = $Control/MarginContainer/pontuacao/pontos_contador

@onready var timer_label: Label = $Control/MarginContainer/timer/timer
@onready var timer: Timer = $Control/MarginContainer/timer/Timer


func _ready() -> void:
	pass



func _process(delta: float) -> void:
	moedas_contador.text = str(Global.coins) + "x"
	vida_contador.text = str(Global.vidas) + "x"
	
	timer_label.text = str(int(timer.time_left))
	
	
	
	if Global.points < 10:
		pontos_contador.text = "000" + str(Global.points)
	elif Global.points < 100:
		pontos_contador.text = "00" + str(Global.points)
	elif Global.points < 1000:
		pontos_contador.text = "0" + str(Global.points)
	elif Global.points < 9999:
		pontos_contador.text = str(Global.points)
	else:
		pontos_contador.text = "9999"


func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.killzone()
		await get_tree().create_timer(1.5).timeout
		get_tree().reload_current_scene()
