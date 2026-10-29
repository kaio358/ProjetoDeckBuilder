extends Control


const MapaDeRotas = "res://cenas/ui/mapa_de_rotas.tscn"
# Mudei o nome do VisualizadorDeck para Visualizador_Deck
# Estava dando "erro" , pois já tinha nome global para isso
const Visualizador_Deck = "res://cenas/deck/visualizadorDeck.tscn"
const Tutorial = "res://cenas/fases/Tutorial.tscn"
@onready var botaoJogar: Button = $VBoxPrincipal/BotaoJogar
@onready var botaoVisualizador: Button = $VBoxPrincipal/BotaoVisualizador
@onready var botaoTutorial: Button = $VBoxPrincipal/BotaoTutorial
@onready var botaoSair: Button = $VBoxPrincipal/BotaoSair

func _ready() -> void:
	# para os botões chamar as funções após serem clicados
	botaoJogar.pressed.connect(_on_botao_jogar_pressed)
	botaoVisualizador.pressed.connect(_on_botao_visualizador_pressed)
	botaoTutorial.pressed.connect(_on_botao_tutorial_pressed)
	botaoSair.pressed.connect(_on_botao_sair_pressed)
	
	# No futuro Tocar a música do menu principal aqui, caso utilize um Singleton de Áudio
	# AudioManager.tocar_musica_menu()

func _on_botao_jogar_pressed() -> void:
	
	DadosJogador.resetarParaNovaRun()
	
	
	if DadosJogador.baralhoGlobal.is_empty():
		
		# DadosJogador.inicializar_baralho_inicial()
		pass
		
	# Libera a progressão para a Fase 1
	DadosJogador.faseDesbloqueada = 1
	
	# Efeito de transição ou fade-out pode ser colocado aqui antes de mudar
	get_tree().change_scene_to_file(MapaDeRotas)

func _on_botao_visualizador_pressed() -> void:
	
	
	
	var visualizador = preload(Visualizador_Deck ).instantiate()
	add_child(visualizador)
	visualizador.abrirVisualizador()

func _on_botao_tutorial_pressed() -> void:
	
	get_tree().change_scene_to_file(Tutorial)

func _on_botao_sair_pressed() -> void:
	# Encerra o jogo imediatamente 
	get_tree().quit()
