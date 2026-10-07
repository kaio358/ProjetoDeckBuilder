extends Node2D


@onready var deck: Deck = $Deck
@onready var baralho_batalha: BaralhoBatalha = $BaralhoBatalha


func _ready() -> void:
	baralho_batalha.configurar(deck)
