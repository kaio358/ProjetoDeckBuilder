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
	# Antes tava : deck.quantidade_cartas(). Agora tá deck.quantidade_pilha_compra()
	# Queremos verificar a quantidade da pilha, não o total de cartas que o jogador tem
	quantidade.text = str(deck.quantidade_pilha_compra())
