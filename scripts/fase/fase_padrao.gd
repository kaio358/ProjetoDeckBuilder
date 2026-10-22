extends Node2D
class_name FasePadrao

@onready var mao: Mao = $Mao


@onready var telaFim: CanvasLayer = $TelaFimDeJogo
@onready var textoFinal: Label = $TelaFimDeJogo/ColorRect/TextoFinal

func _ready() -> void:
	telaFim.hide() # Garante que começa escondida

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
