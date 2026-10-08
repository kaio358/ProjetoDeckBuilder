extends Node2D
class_name VisualizadorDeck


@export_category("Configurações da Carta")
@export var larguraCarta: float = 130.0
@export var alturaCarta: float = 182.0

@export_category("Configurações do Layout")
@export var espacamentoX: float = 15.0
@export var espacamentoY: float = 20.0
@export var margem: float = 50.0

@export_category("Recursos")
@export var cenaCarta: PackedScene


var deck: Deck


@onready var cartas: Node2D = $Cartas


# Recebe o deck que o jogador está usando e atualiza as cartas
# que vão aparecer na tela usando os dados que estão dentro dele.
func configurar(deckDoJogador: Deck) -> void:
	deck = deckDoJogador
	atualizarVisual()


# Apaga as cartas que já estão na tela e cria novamente todas
# as cartas que estão atualmente dentro do deck.
func atualizarVisual() -> void:
	if deck == null:
		return
	
	for cartaVisual in cartas.get_children():
		cartaVisual.queue_free()
	
	var tamanhoTela = get_viewport_rect().size
	var larguraDisponivel = tamanhoTela.x - (margem * 2.0)
	
	# Descobre quantas cartas conseguem ficar na mesma linha
	# antes de precisar começar uma nova linha.
	var cartasPorLinha = int(
		(larguraDisponivel + espacamentoX) /
		(larguraCarta + espacamentoX)
	)
	
	cartasPorLinha = max(cartasPorLinha, 1)
	
	for i in range(deck.cartas.size()):
		var dadosCarta = deck.cartas[i]
		var novaCarta = cenaCarta.instantiate()
		
		cartas.add_child(novaCarta)
		
		if novaCarta.has_method("configurar"):
			novaCarta.configurar(dadosCarta)
		
		redimensionarCarta(novaCarta)
		
		# O resto da conta serve para descobrir em qual coluna
		# e em qual linha a carta atual deve ficar.
		var coluna = i % cartasPorLinha
		var linha = i / cartasPorLinha
		
		var posicaoX = margem + larguraCarta / 2.0
		posicaoX += coluna * (larguraCarta + espacamentoX)
		
		var posicaoY = margem + alturaCarta / 2.0
		posicaoY += linha * (alturaCarta + espacamentoY)
		
		novaCarta.position = Vector2(posicaoX, posicaoY)


# Como a carta original pode ter qualquer tamanho, fazemos uma
# conta para ela ficar com um tamanho padrão dentro do visualizador.
func redimensionarCarta(carta: Node2D) -> void:
	var sprites = carta.find_children("*", "Sprite2D", true, false)
	
	if sprites.is_empty():
		push_warning("A carta não possui nenhum Sprite2D.")
		return
	
	var spriteBase: Sprite2D = sprites[0]
	
	if spriteBase.texture == null:
		push_warning("O Sprite2D da carta não possui textura.")
		return
	
	var tamanhoOriginal = spriteBase.texture.get_size()
	
	if tamanhoOriginal.x <= 0 or tamanhoOriginal.y <= 0:
		return
	
	var escalaX = larguraCarta / tamanhoOriginal.x
	var escalaY = alturaCarta / tamanhoOriginal.y
	
	carta.scale = Vector2(escalaX, escalaY)
