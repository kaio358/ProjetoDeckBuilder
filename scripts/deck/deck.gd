extends Node2D
class_name Deck

var cartas: Array[Dictionary] = []

func _ready() -> void:
	_inicializar_deck()

# Inicializar o deck com cartas de teste variadas
func _inicializar_deck() -> void:
	# Cria 3 cartas de ataque
	for i in range(3):
		var cartaAtaque = {
			"tipo": "ataque",
			"nome": "Ataque " + str(i + 1),
			"custo": 1,
			"texto": "Causa dano direto",
			"dano": 5
		}
		cartas.append(cartaAtaque)
		
	# Cria 2 cartas de magia (suporte)
	for i in range(2):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "cura",
			"nome": "Poção " + str(i + 1),
			"custo": 2,
			"texto": "Recupera vida",
			"poder": 10
		}
		cartas.append(cartaMagia)

# Remover carta
func remover_carta(dadosCarta: Dictionary) -> void:
	cartas.erase(dadosCarta)

# Adicionar carta ao deck
func adicionar_carta(dadosCarta: Dictionary) -> void:
	cartas.append(dadosCarta)

# Quantidade de cartas
func quantidade_cartas() -> int:
	return cartas.size()
