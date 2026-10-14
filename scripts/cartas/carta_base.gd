extends Node2D
class_name CartaBase

@export var cardNome: String = "Nome Padrão"
@export var custoBase: int = 1
@export var cardTexto: String = "Texto Padrão"

# Referências visuais que TODA carta tem (seja ataque, magia, item...)
@onready var labelNome: Label = $CardNome/Nome
@onready var labelCusto: Label = $CostDisplay/CustoBase
@onready var labelTexto: Label = $CardTexto/CardTexto

@onready var spriteDaCarta: Sprite2D = $CardImage
@onready var areaColisao: Area2D = $AreaColisao

# Variáveis de controle de drag & drop (camelCase)
var arrastando: bool = false
var mouseSobre: bool = false
var offsetDoMouse: Vector2 = Vector2.ZERO
var posicaoInicial: Vector2

static var cartaSendoArrastada: CartaBase = null

signal foi_jogada(carta_node)

func _ready() -> void:
	# Atualiza a UI base
	labelCusto.set_text(str(custoBase))
	labelNome.set_text(cardNome)
	labelTexto.set_text(cardTexto)
	
	# Configura os eventos de mouse
	areaColisao.input_pickable = true
	areaColisao.mouse_entered.connect(_on_mouse_entered)
	areaColisao.mouse_exited.connect(_on_mouse_exited)
	
	# Chama uma função extra caso as classes filhas queiram adicionar algo no ready
	_readyCustomizado()

# Função vazia pro filho sobrescrever (Override) se precisar
func _readyCustomizado() -> void:
	pass

func _process(_delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() + offsetDoMouse

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and mouseSobre:
			# Só inicia o arrasto se NENHUMA outra carta estiver sendo arrastada
			if cartaSendoArrastada == null:
				cartaSendoArrastada = self # Trava o arrasto para esta carta
				_iniciarArrasto()
				
		elif not event.pressed and arrastando:
			cartaSendoArrastada = null # Libera a trava para as outras cartas
			_soltarCarta()

func _on_mouse_entered() -> void:
	mouseSobre = true

func _on_mouse_exited() -> void:
	mouseSobre = false

func _iniciarArrasto() -> void:
	arrastando = true
	posicaoInicial = global_position 
	offsetDoMouse = global_position - get_global_mouse_position()
	z_index = 10 

func _soltarCarta() -> void:
	arrastando = false
	z_index = 0
	
	var areas_vizinhas = areaColisao.get_overlapping_areas()
	var alvo_atingido = null
	
	# Procura especificamente se encostou em uma área do grupo "inimigo"
	for area in areas_vizinhas:
		if area.is_in_group("inimigo"):
			# Pega o Node raiz do inimigo (o pai da Area2D)
			alvo_atingido = area.get_parent() 
			
			break 
			
	if alvo_atingido != null:
		# Acertou um inimigo! Passamos ele para a função de efeito.
		executarEfeito(alvo_atingido)
		
		# Fala para a Mão mandar a carta pro cemitério
		foi_jogada.emit(self) 
	else:
		# Soltou no ar ou em lugar inválido, devolve pra mão
		global_position = posicaoInicial
		

# Função genérica de set e get dos dados principais
func configurar(dadosCarta: Dictionary) -> void:
	if dadosCarta.has("nome"): cardNome = dadosCarta["nome"]
	if dadosCarta.has("custo"): custoBase = dadosCarta["custo"]
	if dadosCarta.has("texto"): cardTexto = dadosCarta["texto"]

	labelCusto.set_text(str(custoBase))
	labelNome.set_text(cardNome)
	labelTexto.set_text(cardTexto)
	
	if dadosCarta.has("caminho_imagem"):
		# O comando load() do Godot puxa o arquivo do disco para a memória
		var textura = load(dadosCarta["caminho_imagem"])
		if textura != null:
			spriteDaCarta.texture = textura
		else:
			push_warning("Arte não encontrada no caminho: " + dadosCarta["caminho_imagem"])
	# Passa a bola pra carta filha configurar suas coisas extras (dano, cura, etc)
	_configurarExtra(dadosCarta)

# Outra função vazia pro filho sobrescrever
func _configurarExtra(_dadosCarta: Dictionary) -> void:
	pass

# A função de poder da carta! Cada filho vai implementar a sua
func executarEfeito(alvo: Node2D) -> void:
	push_warning("Aviso: executando carta genérica no alvo: ", alvo.name)
