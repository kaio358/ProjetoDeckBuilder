extends Node2D


@export var cardNome: String = " Card Nome "
@export var custoBase: int = 1
@export var cardTexto: String = " Sei la "
@export var textoDeDano: int  = 1
@export var cardImage: Node2D

@onready var nome: Label = $CardNome/Nome
@onready var custo_base: Label = $CostDisplay/CustoBase
@onready var card_texto: Label = $CardTexto/CardTexto
@onready var texto_de_dano: Label = $CardTexto/TextoDeDano


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custo_base.set_text(str(custoBase))
	nome.set_text(cardNome)
	card_texto.set_text(cardTexto)
	texto_de_dano.set_text(str(textoDeDano))
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
