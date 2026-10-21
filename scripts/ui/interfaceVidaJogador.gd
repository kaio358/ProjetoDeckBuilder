extends Control
class_name BarraVidaJogador

@onready var barraVida: ProgressBar = $BarraVidaJogador
@onready var labelVida: Label = $TextoVidaJogador

#  Só para escudo, igual do inimigoPadrao
@onready var grupoEscudo: Node2D = $GrupoEscudoJogador 
@onready var textoEscudo: Label = $GrupoEscudoJogador/TextoEscudo

func _ready() -> void:
	# Pelo que eu entendi, o '.connect()' é a tela encostando o ouvido na parede.
	# Ela fica escutando o DadosJogador e, quando ouve o grito 'interfaceAlterada',
	# ela roda a função 'atualizarInterface' na mesma hora.
	DadosJogador.interfaceAlterada.connect(atualizarInterface)
	
	atualizarInterface(DadosJogador.vidaAtual, DadosJogador.vidaMaxima, DadosJogador.armaduraAtual)

# Atualiza a vida e o escudo ao mesmo tempo
func atualizarInterface(vidaAtual: int, vidaMaxima: int, armadura: int) -> void:
	if barraVida != null:
		barraVida.min_value = 0
		barraVida.max_value = vidaMaxima
		barraVida.value = vidaAtual
		
	if labelVida != null:
		labelVida.text = str(vidaAtual) + "/" + str(vidaMaxima)
		
	# Ao fazer o show() e hide() direto no Grupo (a pasta) é muito mais seguro,
	# porque assim a imagem e o número aparecem e somem perfeitamente juntos.
	if grupoEscudo != null and textoEscudo != null:
		if armadura > 0:
			textoEscudo.text = str(armadura)
			grupoEscudo.show()
		else:
			grupoEscudo.hide()
