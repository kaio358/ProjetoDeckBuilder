extends Node2D
class_name InimigoPadrao

@export var vidaMaxima: int = 20
@export var nomeInimigo: String = "Inimigo Genérico"
@export var dano_base: int = 5
@export var defesa_base: int = 5

var vidaAtual: int
var armaduraAtual: int = 0
var proximaAcao: String = "ataque" 
var valorAcao: int = 0
# Array que define a ordem exata do que o inimigo vai fazer
@export var padraoAcoes: Array[String] = ["ataque", "espera", "defesa", "espera", "ataque"]
@export var passoInicial: int = 0
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
	passoAtual = passoInicial
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




# Criamos essa função para ser o "cérebro" visual.
# Ela sempre dá uma olhada ao DadosJogador para ver se ocorreu uma mudança para afetar o inimigo em status

#  Bug visual conhecido 
# A matemática da carta de Divisão está funcionando perfeitamente no cálculo de dano,
# mas o texto de intenção  não atualiza na tela em tempo real 
# quando a carta é solta na mesa. 
# Como o prazo de entrega está apertado, vou manter assim por enquanto, já que 
# não quebra a mecânica principal do jogo. Fica como melhoria para uma versão futura!

func atualizarTextoIntencao() -> void:
	# O nosso espião: verifica se o Inimigo escutou o chamado e qual é a conta que ele está tentando fazer
	print("Megafone escutado! Ação atual: ", proximaAcao, " | Divisor no DadosJogador: ", DadosJogador.divisorDanoRecebido)
	
	if proximaAcao == "ataque":
		#  se o número for quebrado (ex: 5 / 2 = 2.5 vira 2)
		var danoReal = int(valorAcao / DadosJogador.divisorDanoRecebido)
		displayIntencao.text = "⚔️ Atacará: " + str(danoReal)
		
	elif proximaAcao == "ataque_forte":
		var danoReal = int(valorAcao / DadosJogador.divisorDanoRecebido)
		displayIntencao.text = "💀 Ataque Massivo: " + str(danoReal)
		
	elif proximaAcao == "defesa":
		displayIntencao.text = "🛡️ Defenderá: " + str(valorAcao)
		
	elif proximaAcao == "espera":
		displayIntencao.text = "⏳ Espera"





func planejarProximoTurno() -> void:
	var acaoDaVez = padraoAcoes[passoAtual]
	
	match acaoDaVez:
		"ataque":
			proximaAcao = "ataque"
			valorAcao = dano_base
		"defesa":
			proximaAcao = "defesa"
			valorAcao = defesa_base
		"espera":
			proximaAcao = "espera"
			valorAcao = 0
			
	# Em vez de escrever o texto na mão, chamamos a função que calcula tudo
	atualizarTextoIntencao()
			
	if displayIntencao != null:
		displayIntencao.show()
		
	passoAtual = (passoAtual + 1) % padraoAcoes.size()


# Função para o inimigo receber penalidades matemáticas das cartas
func sofrerDebuff(tipoDebuff: String, valorDebuff: int) -> void:
	match tipoDebuff:
		"raiz":
			if armaduraAtual > 0:
				# A função sqrt() nativa do Godot calcula a raiz quadrada
				armaduraAtual = int(sqrt(armaduraAtual))
				print(name, " teve o escudo quebrado pela raiz quadrada! Novo escudo: ", armaduraAtual)
				atualizarInterfaceEscudo()
				
		"subtracao":
			# Reduz a força do ataque ou da defesa que o inimigo planejava fazer
			valorAcao -= valorDebuff
			if valorAcao < 0:
				valorAcao = 0 # Impede que o inimigo cure o jogador com dano negativo kkk
				
			print(name, " sofreu um corte negativo! Intenção caiu para: ", valorAcao)
			atualizarTextoIntencao() # Atualiza o balão na hora!
			
	
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
		# Remove do grupo para cartas e turnos ignorarem este orc imediatamente
		remove_from_group("inimigo")
		if displayIntencao != null:
			displayIntencao.hide()
		
		# Toca a morte e pausa o código até ela terminar
		arteInimigo.play("morrendo")
		await arteInimigo.animation_finished 
		
		verificarVitoria()
		queue_free()

func verificarVitoria() -> void:
	# Como o queue_free() demora 1 frame, o inimigo atual ainda está no grupo.
	# Se ele for o ÚLTIMO, o tamanho do grupo será 1.
	var inimigos_vivos = get_tree().get_nodes_in_group("inimigo").size()
	if inimigos_vivos <= 1:
		get_tree().current_scene.mostrarVitoria()
	
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
