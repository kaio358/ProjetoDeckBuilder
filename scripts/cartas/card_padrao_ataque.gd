extends Node2D

@export var cardNome: String = "Card Nome"
@export var custoBase: int = 1
@export var cardTexto: String = "Sei la"
@export var textoDeDano: int = 1
@export var cardImage: Node2D

@onready var nome: Label = $CardNome/Nome
@onready var custo_base: Label = $CostDisplay/CustoBase
@onready var card_texto: Label = $CardTexto/CardTexto
@onready var texto_de_dano: Label = $CardTexto/TextoDeDano

# Arrastar objeto
@onready var area_colisao: Area2D = $AreaColisao

var arrastando: bool = false
var mouseSobre: bool = false
var offsetDoMouse: Vector2 = Vector2.ZERO
var posicaoInicial: Vector2

func _ready() -> void:
	custo_base.set_text(str(custoBase))
	nome.set_text(cardNome)
	card_texto.set_text(cardTexto)
	texto_de_dano.set_text(str(textoDeDano))
	
	area_colisao.input_pickable = true
	area_colisao.mouse_entered.connect(_on_mouse_entered)
	area_colisao.mouse_exited.connect(_on_mouse_exited)

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
	
	
