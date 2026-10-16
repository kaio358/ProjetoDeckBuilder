extends Node2D
class_name InimigoPadrao

@export var vidaMaxima: int = 20
var vidaAtual: int
var proximoDano: int = 5 # O dano que ele planeja causar

# Referências aos nós filhos 
@onready var arteInimigo: AnimatedSprite2D = $ArteInimigo
@onready var labelVida: Label = $InterfaceVida/TextoVida
@onready var barraVida: ProgressBar = $InterfaceVida/BarraVida 
@onready var displayIntencao: Label = $DisplayIntencao

func _ready() -> void:
	vidaAtual = vidaMaxima
	atualizarInterfaceVida()
	
	# Garantia que ele comece na animação certa
	arteInimigo.play("idle")
	
	# Conecta o sinal para saber quando a animação de ataque termina
	arteInimigo.animation_finished.connect(_onAnimacaoTerminou)
	# O inimigo já "pensa" no que vai fazer logo que nasce!
	planejarProximoTurno()

func atualizarInterfaceVida() -> void:
	if labelVida != null:
		labelVida.text = str(vidaAtual) + "/" + str(vidaMaxima)

	if barraVida != null:
		barraVida.max_value = vidaMaxima
		barraVida.value = vidaAtual

func planejarProximoTurno() -> void:
	# No futuro, podemos usar 'match' aqui para ele escolher aleatoriamente entre atacar, defender ou buffar
	proximoDano = 5 
	
	if displayIntencao != null:
		# Usa um emoji e o número de dano para o jogador saber
		displayIntencao.text = "⚔️ Atacará: " + str(proximoDano)
		displayIntencao.show() # Garante que está visível

# === FUNÇÃO QUE A CARTA DE ATAQUE VAI CHAMAR ===
func receberDano(dano: int) -> void:
	vidaAtual -= dano
	print(name, " recebeu ", dano, " de dano! Vida restante: ", vidaAtual)
	
	atualizarInterfaceVida()
	
	# Pisca de vermelho rapidinho (efeito clássico de dano)
	arteInimigo.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.2).timeout
	arteInimigo.modulate = Color(1, 1, 1)
	
	if vidaAtual <= 0:
		morrer()

func atacarJogador() -> void:
	arteInimigo.play("atacando")
	
	# Aplica o dano diretamente no gerenciador global de dados do jogador
	DadosJogador.receberDano(proximoDano) 
	
func _onAnimacaoTerminou() -> void:
	# Se ele terminou de atacar, volta a ficar parado
	if arteInimigo.animation == "atacando":
		arteInimigo.play("idle")

func morrer() -> void:
	print(name, " foi derrotado!")
	queue_free()
