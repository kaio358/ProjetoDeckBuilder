extends Node2D

@onready var deck: Deck = $Deck

# Está dando o erro no teste ... Mais tarde eu, Kaio, confiro
func _ready() -> void:
	print("Quantidade de cartas: ",deck.quantidade_cartas())

	for carta in deck.cartas:
		print(carta)
