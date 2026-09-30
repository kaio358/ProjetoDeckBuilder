extends Node2D

@export var cardNome: String = "Esse Nome"
@export var custoBase: int = 3
@export var cardTexto: String = " Texto Foda "
@export var cardImage: Node2D

@onready var nome: Label = $CardNome/Nome
@onready var card_image: Sprite2D = $CardImage
@onready var card_texto: Label = $CardTexto/CardTexto
@onready var custo_base: Label = $CostDisplay/CustoBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custo_base.set_text(str(custoBase))
	nome.set_text(cardNome)
	card_texto.set_text(cardTexto)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
