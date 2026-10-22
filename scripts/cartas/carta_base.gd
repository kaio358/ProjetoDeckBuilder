extends Node2D
class_name CartaBase

@export var cardNome: String = "Nome Padrão"
@export var custoBase: int = 1
@export var cardTexto: String = "Texto Padrão"
# Essa váriavel é para solucionar cartas mágicas que ...
# ... não precisam necessariamente de alvo
var tipoCarta: String = "ataque"

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

# Variaveis de memória da mão 
var posicaoNoLeque: Vector2
var rotacaoNoLeque: float
var escalaNoLeque: Vector2 = Vector2(1, 1)

# Alvos matemáticos para o _process 
var posicaoAlvo: Vector2
var rotacaoAlvo: float
var escalaAlvo: Vector2 = Vector2(1, 1)

static var cartaSendoArrastada: CartaBase = null

signal foi_jogada(carta_node)

func _ready() -> void:
	# Atualiza a UI base
	labelCusto.set_text(str(custoBase))
	labelNome.set_text(cardNome)
	labelTexto.set_text(cardTexto)
	# Não está funcionando ---------
	labelCusto.add_theme_font_size_override("font_size", 50)
	labelNome.add_theme_font_size_override("font_size", 40)
	labelTexto.add_theme_font_size_override("font_size", 30)
	# ----------------------------------
	# Configura os eventos de mouse
	areaColisao.input_pickable = true
	areaColisao.mouse_entered.connect(_on_mouse_entered)
	areaColisao.mouse_exited.connect(_on_mouse_exited)
	
	# Inicializa alvos para evitar saltos no primeiro frame
	posicaoAlvo = position
	rotacaoAlvo = rotation
	escalaAlvo = scale
	
	# Chama uma função extra caso as classes filhas queiram adicionar algo no ready
	_readyCustomizado()

# Função vazia pro filho sobrescrever (Override) se precisar
func _readyCustomizado() -> void:
	pass

# Novo motor matematico
func _process(delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() + offsetDoMouse
	else:
		# Aproxima a posição atual do alvo a cada frame (matemática acadêmica)
		position = position.lerp(posicaoAlvo, 12.0 * delta)
		rotation = lerp_angle(rotation, rotacaoAlvo, 12.0 * delta)
		scale = scale.lerp(escalaAlvo, 12.0 * delta)

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

# Função dos dados da mão
func configurarLeque(pos: Vector2, rot: float, esc: Vector2) -> void:
	posicaoNoLeque = pos
	rotacaoNoLeque = rot
	escalaNoLeque = esc 
	
	# Se o mouse não está nela e não está arrastando, ela obedece a mão
	if not mouseSobre and not arrastando:
		posicaoAlvo = posicaoNoLeque
		rotacaoAlvo = rotacaoNoLeque
		escalaAlvo = escalaNoLeque

func _on_mouse_entered() -> void:
	mouseSobre = true
	# Se não tem ninguém segurando a carta, faz o efeito Hover
	if not arrastando and cartaSendoArrastada == null:
		z_index = 10
		posicaoAlvo = posicaoNoLeque + Vector2(0, -60) # Sobe 60px
		rotacaoAlvo = 0.0 # Fica reta
		escalaAlvo = escalaNoLeque * 1.10 # Cresce 10% sobre o tamanho certo

func _on_mouse_exited() -> void:
	mouseSobre = false
	# Tira o mouse e devolve os valores normais do leque
	if not arrastando and cartaSendoArrastada == null:
		z_index = 0
		posicaoAlvo = posicaoNoLeque
		rotacaoAlvo = rotacaoNoLeque
		escalaAlvo = escalaNoLeque

func _iniciarArrasto() -> void:
	arrastando = true
	posicaoInicial = global_position 
	offsetDoMouse = global_position - get_global_mouse_position()
	z_index = 10 
	rotation = 0.0 # Mantém reta enquanto arrasta

func _soltarCarta() -> void:
	arrastando = false
	z_index = 0
	
	if tipoCarta == "magia":
		# Verifica se a carta foi arrastada pelo menos 100 pixels para CIMA (direção ao meio da tela)
		if global_position.y < posicaoInicial.y - 100:
			if DadosJogador.tentarGastarMana(custoBase):
				# Magias não precisam de alvo, passamos 'null'
				executarEfeito(null)
				foi_jogada.emit(self)
			else:
				_retornarAoLequeSuavemente()
		else:
			# Se só clicou e soltou no mesmo lugar, devolve pra mão
			_retornarAoLequeSuavemente()
	else:
		var areas_vizinhas = areaColisao.get_overlapping_areas()
		var alvo_atingido = null
		
		# Procura especificamente se encostou em uma área do grupo "inimigo"
		for area in areas_vizinhas:
			if area.is_in_group("inimigo"):
				# Pega o Node raiz do inimigo (o pai da Area2D)
				alvo_atingido = area.get_parent() 
				break 
				
		if alvo_atingido != null:
			#  A carta pergunta se pode gastar a mana (custoBase).
			# Se a resposta for true, ela gasta, executa o efeito e vai pro cemitério.
			if DadosJogador.tentarGastarMana(custoBase):
				# Acertou um inimigo! Passamos ele para a função de efeito.
				executarEfeito(alvo_atingido)
				
				# Fala para a Mão mandar a carta pro cemitério
				foi_jogada.emit(self) 
				
			else:
				# Sem mana, devolve pra mão usando o lerp suave
				_retornarAoLequeSuavemente()
		else:
			# Soltou no ar ou em lugar inválido, devolve pra mão suavemente
			_retornarAoLequeSuavemente()

func _retornarAoLequeSuavemente() -> void:
	# Ajusta os alvos e o _process faz o resto
	posicaoAlvo = posicaoNoLeque
	rotacaoAlvo = rotacaoNoLeque
	escalaAlvo = escalaNoLeque

# Função genérica de set e get dos dados principais
func configurar(dadosCarta: Dictionary) -> void:
	if dadosCarta.has("nome"): cardNome = dadosCarta["nome"]
	if dadosCarta.has("custo"): custoBase = dadosCarta["custo"]
	if dadosCarta.has("texto"): cardTexto = dadosCarta["texto"]
	if dadosCarta.has("tipo"): tipoCarta = dadosCarta["tipo"]
	
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
