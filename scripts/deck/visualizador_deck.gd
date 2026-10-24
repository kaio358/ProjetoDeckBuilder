extends CanvasLayer
class_name VisualizadorDeck

@export_category("Configurações do Layout")
@export var escalaVitrine: float = 0.5
@export var espacamentoX: float = 160.0
@export var espacamentoY: float = 230.0
@export var margem: float = 50.0

@export_category("Cenas Base das Cartas")
@export var cenaBaseAtaque: PackedScene
@export var cenaBaseMagia: PackedScene

@onready var cartas: Node2D = $Cartas

func _ready() -> void:
	# O visualizador nasce invisível
	hide()

# Chame esta função quando o jogador clicar no ícone do deck no mapa
func abrirVisualizador() -> void:
	show()
	atualizarVisual()

func fecharVisualizador() -> void:
	hide()

func atualizarVisual() -> void:
	# Limpa a tela antes de desenhar
	for cartaVisual in cartas.get_children():
		cartaVisual.queue_free()
	
	# Puxa o baralho diretamente do Autoload, sem depender de batalhas
	var baralho = DadosJogador.baralhoGlobal
	if baralho.is_empty():
		return
		
	var tamanhoTela = get_viewport().get_visible_rect().size
	var larguraDisponivel = tamanhoTela.x - (margem * 2.0)
	
	var cartasPorLinha = int((larguraDisponivel + espacamentoX) / espacamentoX)
	cartasPorLinha = max(cartasPorLinha, 1)
	
	for i in range(baralho.size()):
		var dadosCarta = baralho[i]
		var tipoCarta = dadosCarta.get("tipo", "ataque")
		
		var cenaCorreta = cenaBaseAtaque if tipoCarta == "ataque" else cenaBaseMagia
		
		if cenaCorreta == null:
			push_error("Erro: Cena base não vinculada!")
			continue
			
		var novaCarta = cenaCorreta.instantiate()
		cartas.add_child(novaCarta)
		
		# A ordem correta: instanciar -> configurar -> transformar
		novaCarta.configurar(dadosCarta)
		novaCarta.transformarEmVitrine(escalaVitrine)
		
		var coluna = i % cartasPorLinha
		var linha = i / cartasPorLinha
		
		var posicaoX = margem + (coluna * espacamentoX)
		var posicaoY = margem + (linha * espacamentoY)
		
		novaCarta.position = Vector2(posicaoX, posicaoY)


func _on_botao_fechar_pressed() -> void:
	fecharVisualizador()
