extends Node2D
class_name CardPadraoMagia
@export var cardNome: String = "Esse Nome"
@export var custoBase: int = 3
@export var cardTexto: String = " Texto Foda "
@export var cardImage: Node2D

@onready var nome: Label = $CardNome/Nome
@onready var card_image: Sprite2D = $CardImage
@onready var card_texto: Label = $CardTexto/CardTexto
@onready var custo_base: Label = $CostDisplay/CustoBase


# Arrastar objeto
@onready var area_2d: Area2D = $Area2D

var arrastando: bool = false
var mouseSobre: bool = false
var offsetDoMouse: Vector2 = Vector2.ZERO
var posicaoInicial: Vector2



func _ready() -> void:
	custo_base.set_text(str(custoBase))
	nome.set_text(cardNome)
	card_texto.set_text(cardTexto)
	
	area_2d.input_pickable = true
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() + offsetDoMouse

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and mouseSobre:
			_iniciar_arrasto()
		elif not event.pressed and arrastando:
			_soltar_carta()

func _on_mouse_entered() -> void:
	mouseSobre = true

func _on_mouse_exited() -> void:
	mouseSobre = false

func _iniciar_arrasto() -> void:
	arrastando = true
	posicaoInicial = global_position 
	offsetDoMouse = global_position - get_global_mouse_position()
	z_index = 10 

func _soltar_carta() -> void:
	arrastando = false
	z_index = 0
	global_position = posicaoInicial
	
func configurar(dados_carta: Dictionary) -> void:
	if dados_carta.has("nome"):
		cardNome = dados_carta["nome"]

	if dados_carta.has("custo"):
		custoBase = dados_carta["custo"]

	if dados_carta.has("texto"):
		cardTexto = dados_carta["texto"]



	custo_base.set_text(str(custoBase))
	nome.set_text(cardNome)
	card_texto.set_text(cardTexto)
	


# Em manutenção, uma função PAI do Objeto
# A função a principio identificaria se é cura, debuff, buff,entre outros.

func tipo_card() ->void:
	#if(CardPadraoMagia is Cura):
	#	print("Teste")
	pass
