extends Control

# Pegando as referências dos nós visuais que criei lá na árvore de cena
@onready var sliderVolume: HSlider = $CaixaCentral/SliderVolume
@onready var botaoTelaCheia: CheckButton = $CaixaCentral/BotaoTelaCheia
@onready var botaoVoltar: Button = $CaixaCentral/BotaoVoltar

func _ready() -> void:
	# Pega o volume atual do sistema para a barrinha não carregar sempre no meio
	var indiceCanalAudio = AudioServer.get_bus_index("Master")
	var volumeDbAtual = AudioServer.get_bus_volume_db(indiceCanalAudio)
	
	# acho que o db_to_linear faz o caminho inverso do linear_to_db (transforma dB de volta em 0.0 a 1.0)
	# aí multiplicamos por 100.0 para alinhar com o Slider
	sliderVolume.value = db_to_linear(volumeDbAtual) * 100.0

	# Conectando os sinais direto por código! Assim não preciso ir na aba "Sinais" do Inspetor toda hora.
	# Quando o evento acontecer, ele chama a função correspondente lá embaixo.
	botaoVoltar.pressed.connect(clicouVoltar)
	sliderVolume.value_changed.connect(mudouVolume)
	botaoTelaCheia.toggled.connect(mudouTelaCheia)
	
	# Quando o jogador entra nas configurações, eu preciso checar no sistema (DisplayServer) 
	# se o jogo já está em tela cheia. Se estiver, eu deixo o botão marcado (true).
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		botaoTelaCheia.button_pressed = true

func mudouVolume(valor: float) -> void:
	# O Godot guarda os sons em "Canais" (Buses). O "Master" é o canal principal/geral que controla tudo.
	var indiceCanalAudio = AudioServer.get_bus_index("Master")
	
	if valor == 0:
		# Se a barrinha chegar no 0, eu muto o som completamente para evitar chiados baixinhos
		AudioServer.set_bus_mute(indiceCanalAudio, true)
	else:
		# Tira do mudo caso o jogador aumente de novo
		AudioServer.set_bus_mute(indiceCanalAudio, false)
		
		# Aprendizado importante: O Godot não entende volume de 0 a 100 direto, ele usa Decibéis (dB).
		# Pelo que eu entendi o valor (ex: 50), divido por 100 (fica 0.5) e uso essa função linear_to_db 
		# para converter pro formato que o motor de áudio entende!
		AudioServer.set_bus_volume_db(indiceCanalAudio, linear_to_db(valor / 100.0))

func mudouTelaCheia(ativado: bool) -> void:
	# O CheckButton sempre envia "true" ou "false" (ativado). 
	# Dependendo do que vier, eu mando o DisplayServer maximizar ou virar janela.
	if ativado:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func clicouVoltar() -> void:
	queue_free()
	# Manda o jogador de volta para a tela inicial
	#get_tree().change_scene_to_file("res://cenas/MenuPrincipal.tscn")
