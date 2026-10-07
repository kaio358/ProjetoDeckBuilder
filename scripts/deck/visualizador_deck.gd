extends Node2D
class_name VisualizadorDeck


@export var cena_carta: PackedScene

var deck: Deck


@onready var cartas: Node2D = $Cartas


func configurar(deck_do_jogador: Deck) -> void:
	deck = deck_do_jogador
	atualizar_visual()


func atualizar_visual() -> void:
	if deck == null:
		return
	
	# Limpa as cartas que já estavam sendo exibidas
	for carta_visual in cartas.get_children():
		carta_visual.queue_free()
	
	# Cria uma representação visual para cada carta do Deck
	for dados_carta in deck.cartas:
		var nova_carta = cena_carta.instantiate()
		
		cartas.add_child(nova_carta)
		
		if nova_carta.has_method("configurar"):
			nova_carta.configurar(dados_carta)
