extends Node2D
class_name Deck

var cartas: Array = []

func _ready() -> void:
	pass
	

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

# adicionar carta ao deck
