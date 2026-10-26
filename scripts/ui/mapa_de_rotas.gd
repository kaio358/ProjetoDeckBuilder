extends Control

@onready var btnFloresta: Button = $Rotas/BotaoFase1
@onready var btnVila: Button = $Rotas/BotaoFase2
@onready var btnCastelo: Button = $Rotas/BotaoFase3


func _ready() -> void:
	_atualizarBloqueios()

func _atualizarBloqueios() -> void:
	# Trava tudo que for avançado por padrão
	btnVila.disabled = true
	btnCastelo.disabled = true
	
	# Libera a Vila se a Floresta foi vencida
	if DadosJogador.faseDesbloqueada >= 2:
		btnVila.disabled = false
		
	# Libera o Castelo se a Vila foi vencida
	if DadosJogador.faseDesbloqueada >= 3:
		btnCastelo.disabled = false

func _on_botao_fase_1_pressed() -> void:
	# descarrega a cena atual e carregar a próxima
	get_tree().change_scene_to_file("res://cenas/fases/Fase1.tscn")

func _on_botao_fase_2_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/fases/Fase2.tscn")


func _on_botao_fogueira_pressed() -> void:
	print("Carregando cena da Fogueira (Ainda não criada)")
	# get_tree().change_scene_to_file("res://caminho/para/Fogueira.tscn")


func _on_botao_ver_deck_pressed() -> void:
	$VisualizadorDeck.abrirVisualizador()
