extends Node2D
class_name BaralhoBatalha


var deck: Deck


@onready var quantidade: Label = $Quantidade


func configurar(deckDoJogador: Deck) -> void:
	deck = deckDoJogador
	atualizar_visual()


func atualizar_visual() -> void:
	if deck == null:
		return
	
	quantidade.text = str(deck.quantidade_cartas())
