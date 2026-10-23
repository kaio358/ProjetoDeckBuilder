extends Node2D
class_name FasePadrao

@onready var mao: Mao = $Mao


@onready var telaFim: CanvasLayer = $TelaFimDeJogo
@onready var textoFinal: Label = $TelaFimDeJogo/ColorRect/TextoFinal

func _ready() -> void:
	telaFim.hide() 


# Funções que serão chamadas quando alguém morrer
func mostrarVitoria() -> void:
	print("PASSO 3: A FasePadrao recebeu o aviso de vitória!")
	telaFim.show()
	textoFinal.text = "VITÓRIA!\nO inimigo foi derrotado!"
	textoFinal.add_theme_color_override("font_color", Color.GREEN_YELLOW)
	get_tree().paused = true # <--- ISSO PAUSA TUDO (cartas, monstros, turnos)

func mostrarDerrota() -> void:
	telaFim.show()
	textoFinal.text = "DERROTA...\nArthur caiu em combate."
	textoFinal.add_theme_color_override("font_color", Color.CRIMSON)
	get_tree().paused = true # <--- ISSO PAUSA TUDO


# Função ao final da fase para avançar 
func _on_botao_continuar_pressed() -> void:
	get_tree().paused = false
	
	# Se ele acabou de passar da fase 1, libera a fase 2
	if DadosJogador.faseDesbloqueada == 1:
		DadosJogador.faseDesbloqueada = 2
	
	# Troca para a tela do Mapa 
	get_tree().change_scene_to_file("res://cenas/ui/mapa_de_rotas.tscn")
