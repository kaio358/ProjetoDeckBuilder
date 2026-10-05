extends Node2D

@onready var mao: Mao = $Mao

func _ready() -> void:
	for i in range(5):
		var dados_carta = {
			"nome": "Ataque " + str(i + 1),
			"custo": 1,
			"texto": "Causa dano",
			"dano": 5 + i
		}

		mao.adicionar_carta(dados_carta)
		
		
