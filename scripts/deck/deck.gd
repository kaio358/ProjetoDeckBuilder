extends Node2D
class_name Deck

var cartas: Array[Dictionary] = []

func _ready() -> void:
	_inicializar_deck()

# Inicializar o deck
func _inicializar_deck() -> void:
	for i in range(5):
		var carta = {
			"nome": "Ataque " + str(i + 1),
			"custo": 1,
			"texto": "Causa dano",
			"dano": 5
		}
		
		cartas.append(carta)
		
# get cartas disponiveis

# Remover carta
func remover_carta(dadosCarta: Dictionary) -> void:
	cartas.erase(dadosCarta)
# adicionar carta ao deck
func adicionar_carta(dadosCarta: Dictionary) -> void:
	cartas.append(dadosCarta)

# Quantidade de cartas
func quantidade_cartas() -> int:
	return cartas.size()
