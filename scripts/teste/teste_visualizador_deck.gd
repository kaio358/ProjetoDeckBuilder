extends Node2D


@onready var deck: Deck = $Deck
@onready var visualizador_deck: VisualizadorDeck = $VisualizadorDeck


func _ready() -> void:
	visualizador_deck.configurar(deck)
