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
	for i in range(3):
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
		
	for i in range(2):
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


func comprar_carta() -> Dictionary:
	# Se a pilha de compra esvaziar, pega o descarte e embaralha de novo
	# Igual ao jogo Rogue Adventure: Roguelike RPG
	if pilhaCompra.is_empty():
		if pilhaDescarte.is_empty():
			push_warning("Aviso: Nenhuma carta na compra e nem no descarte!")
			# Retorna dicionário vazio para não quebrar o jogo
			# Vai por mim, você não quer ver esse erro
			return {} 
		
		print("Embaralhando a pilha de descarte...")
		pilhaCompra = pilhaDescarte.duplicate()
		pilhaCompra.shuffle()
		pilhaDescarte.clear()
	
	# pop_back() remove o último item do array e o devolve. 
	# É perfeito para simular puxar a carta do topo do baralho!
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
