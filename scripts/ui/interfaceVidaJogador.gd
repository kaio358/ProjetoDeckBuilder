extends Control
class_name BarraVidaJogador

@onready var barraVida: ProgressBar = $BarraVidaJogador
@onready var labelVida: Label = $TextoVidaJogador

func _ready() -> void:
	# Conecta o sinal do Autoload global
	DadosJogador.vidaAlterada.connect(atualizarInterface)
	
	# Configura o estado inicial da barra na tela
	atualizarInterface(DadosJogador.vidaAtual, DadosJogador.vidaMaxima)

func atualizarInterface(vidaAtual: int, vidaMaxima: int) -> void:
	if barraVida != null:
		barraVida.min_value = 0
		barraVida.max_value = vidaMaxima
		barraVida.value = vidaAtual
		
	if labelVida != null:
		labelVida.text = str(vidaAtual) + "/" + str(vidaMaxima)
