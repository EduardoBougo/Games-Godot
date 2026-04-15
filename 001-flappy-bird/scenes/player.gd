extends CharacterBody2D

#Constantes do jogo
const JUMP_VELOCITY = -350.0 # A força do pulo

#Variaveis de fisica
var gravity = 980.0 #Aceleração da gravidade em pixels;segundos^2

func _ready():
	#Trava o processo da fisica quando o jogo começa
	set_physics_process(false)

func _physics_process(delta):
	velocity.y += gravity * delta
	rotation = lerp(rotation, deg_to_rad(-260), 2 * delta)
	
	#Verifica a entrada do jogador para pular 
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	
	#Move o passaro
	move_and_slide()

#Função para iniciar o jogo para o passaro
func start():
	#Reposiciona o passaro no inicio 
	position = get_viewport_rect().size / 2
	#Ativa a fisica
	set_physics_process(true)
	rotation_degrees = 0
