extends Node2D
class_name Deck

# Lista fixa com TODAS as cartas que o jogador possui na coleção
var cartas: Array[Dictionary] = []

# Pilhas dinâmicas usadas APENAS durante o combate
var pilhaCompra: Array[Dictionary] = []
var pilhaDescarte: Array[Dictionary] = []

func _ready() -> void:
	_inicializar_deck()
	# Prepara as pilhas logo que o deck é criado na cena
	_preparar_batalha()

# Inicializa o deck com cartas de teste variadas (mantemos igual)
func _inicializar_deck() -> void:
	for i in range(8):
		# Mais tarde coloco a parte de imagem, vai dar trabalho
		var cartaAtaque = {
			"tipo": "ataque",
			"nome": "Ataque " + str(i + 1),
			"custo": 1,
			"texto": "Causa dano direto",
			"dano": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/cavaleiro-removebg-preview.png"
		}
		cartas.append(cartaAtaque)
		
	for i in range(6):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "cura",
			"nome": "Poção " + str(i + 1),
			"custo": 2,
			"texto": "Recupera vida",
			"poder": 10,
			"caminho_imagem": "res://sprites/cartas_imagens/cavaleiro-removebg-preview.png"
		}
		cartas.append(cartaMagia)

# --- NOVA LÓGICA DE COMBATE ABAIXO ---

# Copia as cartas originais para a pilha de compra e embaralha
func _preparar_batalha() -> void:
	# Copia as cartas da coleção para começar a batalha.
	pilhaCompra = cartas.duplicate(true) # True para copiar tudo!! Não só a estrutura 
	pilhaCompra.shuffle()
	pilhaDescarte.clear()


# Dentro do arquivo deck.gd

func comprar_carta() -> Dictionary:
	# Se o baralho de compra está vazio:
	if pilhaCompra.is_empty():
		if pilhaDescarte.is_empty():
			return {} # Acabaram as cartas do jogo todo
		
		print("Baralho vazio! Embaralhando o cemitério (descarte)...")
		# 1. Copia o cemitério de volta para a pilha de compra
		pilhaCompra = pilhaDescarte.duplicate()
		# 2. Embaralha tudo
		pilhaCompra.shuffle()
		# 3. Limpa o cemitério
		pilhaDescarte.clear()
		
	
	# Retira a carta do topo do baralho e entrega para a Mão
	return pilhaCompra.pop_back()

# Recebe uma carta jogada (ou que sobrou na mão) e joga no lixo
func enviar_para_descarte(dadosCarta: Dictionary) -> void:
	# Evita adicionar dicionários vazios no descarte
	if not dadosCarta.is_empty():
		pilhaDescarte.append(dadosCarta)

# Quantidade de cartas totais (coleção)
func quantidade_cartas() -> int:
	return cartas.size()

# Quantidade de cartas disponíveis para compra no momento
func quantidade_pilha_compra() -> int:
	return pilhaCompra.size()
