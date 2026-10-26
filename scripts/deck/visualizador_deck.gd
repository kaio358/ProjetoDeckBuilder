extends CanvasLayer
class_name VisualizadorDeck

@export_category("Configurações da Vitrine")
@export var escalaVitrine: float = 0.35
@export var colunas: int = 4

@export_category("Cenas Base das Cartas")
@export var cenaBaseAtaque: PackedScene
@export var cenaBaseMagia: PackedScene


@onready var gridCartas: GridContainer = $ScrollContainer/MarginContainer/GridContainer


func _ready() -> void:
	gridCartas.columns = colunas

	
	
	fecharVisualizador()

func abrirVisualizador() -> void:
	self.visible = true
	self.process_mode = Node.PROCESS_MODE_INHERIT 
	atualizarVisual()

func fecharVisualizador() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED 
	
func atualizarVisual() -> void:
	# Limpa o grid antes de desenhar
	for filho in gridCartas.get_children():
		filho.queue_free()
	
	var baralho = DadosJogador.baralhoGlobal
	if baralho.is_empty():
		return
		
	for dadosCarta in baralho:
		var tipoCarta = dadosCarta.get("tipo", "ataque")
		var cenaCorreta = cenaBaseAtaque if tipoCarta == "ataque" else cenaBaseMagia
		
		if cenaCorreta == null:
			push_error("Erro: Cena base não vinculada!")
			continue
			
		# 1. Cria a embalagem para organizar
		var embalagem = Control.new()
		embalagem.custom_minimum_size = Vector2(150, 220)
		
		# 2. Instancia a carta visual
		var novaCarta = cenaCorreta.instantiate()
		
		# 3. Monta a hierarquia
		embalagem.add_child(novaCarta)
		gridCartas.add_child(embalagem)
		
		# 4. Injeta os dados e aciona o Modo Vitrine para ela caber na embalagem
		novaCarta.configurar(dadosCarta)
		novaCarta.transformarEmVitrine(escalaVitrine)


func _on_botao_fechar_pressed() -> void:
	fecharVisualizador()
