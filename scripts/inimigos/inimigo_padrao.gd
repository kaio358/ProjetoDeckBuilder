extends Node2D
class_name InimigoPadrao

@export var vidaMaxima: int = 20
var vidaAtual: int
var armaduraAtual: int = 0
var proximaAcao: String = "ataque" 
var valorAcao: int = 0
# Array que define a ordem exata do que o inimigo vai fazer
@export var padraoAcoes: Array[String] = ["ataque", "espera", "defesa", "espera", "ataque"]
var passoAtual: int = 0

# Referências aos nós filhos
@onready var arteInimigo: AnimatedSprite2D = $ArteInimigo
@onready var labelVida: Label = $InterfaceVida/TextoVida
@onready var barraVida: ProgressBar = $InterfaceVida/BarraVida 
@onready var displayIntencao: Label = $DisplayIntencao
@onready var grupoEscudo: Node2D = $GrupoEscudo 
@onready var textoEscudo: Label = $GrupoEscudo/TextoEscudo

func _ready() -> void:
	vidaAtual = vidaMaxima
	atualizarInterfaceVida()
	
	# Só para ter certeza que o escudo não aparece 
	atualizarInterfaceEscudo()
	
	# Garante que ele comece na animação certa
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

func atualizarInterfaceEscudo() -> void:
	if grupoEscudo != null and textoEscudo != null:
		print("Atualizando interface do escudo. Armadura atual é: ", armaduraAtual)
		if armaduraAtual > 0:
			textoEscudo.text = str(armaduraAtual)
			grupoEscudo.show()
		else:
			grupoEscudo.hide() # Quando não tem armadura, o ícone some!

func planejarProximoTurno() -> void:
	var acaoDaVez = padraoAcoes[passoAtual]
	
	match acaoDaVez:
		"ataque":
			proximaAcao = "ataque"
			valorAcao = 5
			displayIntencao.text = "⚔️ Atacará: " + str(valorAcao)
		"defesa":
			proximaAcao = "defesa"
			valorAcao = 5
			displayIntencao.text = "🛡️ Defenderá: " + str(valorAcao)
		"espera":
			proximaAcao = "espera"
			valorAcao = 0
			displayIntencao.text = "⏳ Espera"
			
	if displayIntencao != null:
		displayIntencao.show()
		
	passoAtual = (passoAtual + 1) % padraoAcoes.size()

# Ao causar dano, essa função de ataque da carta
func receberDano(dano: int) -> void:
	var danoRestante = dano
	
	if armaduraAtual > 0:
		if danoRestante >= armaduraAtual:
			danoRestante -= armaduraAtual
			armaduraAtual = 0
			print("Escudo do inimigo quebrado!")
		else:
			armaduraAtual -= danoRestante
			danoRestante = 0
			print("O escudo absorveu o dano. Escudo restante: ", armaduraAtual)
		atualizarInterfaceEscudo()
		
	if danoRestante > 0:
		vidaAtual -= danoRestante
		print(name, " recebeu ", danoRestante, " de dano! Vida restante: ", vidaAtual)
		atualizarInterfaceVida()
		
		# Pisca de vermelho rapidinho (efeito clássico de dano)
		arteInimigo.modulate = Color(1, 0.3, 0.3)
		await get_tree().create_timer(0.2).timeout
		arteInimigo.modulate = Color(1, 1, 1)
	
	if vidaAtual <= 0:
		# Em vez de só sumir em silêncio, ele avisa a cena principal
		print("PASSO 1: Inimigo chegou a zero de vida.")
		print("PASSO 2: A cena principal atual é: ", get_tree().current_scene.name)
		get_tree().current_scene.mostrarVitoria()
		queue_free()
	
func executarAcaoTurno() -> void:
	if displayIntencao != null:
		displayIntencao.hide()
		
	armaduraAtual = 0
	atualizarInterfaceEscudo()

	match proximaAcao:
		"ataque":
			arteInimigo.play("atacando")
			DadosJogador.receberDano(valorAcao) 
		"defesa":
			armaduraAtual = valorAcao
			atualizarInterfaceEscudo()
			print(name, " assumiu postura defensiva!")
		"espera":
			print(name, " está observando o jogador...")
	
func _onAnimacaoTerminou() -> void:
	# Se ele terminou de atacar, volta a ficar parado
	if arteInimigo.animation == "atacando":
		arteInimigo.play("idle")
