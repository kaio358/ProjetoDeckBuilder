extends Control
class_name InterfaceMana

@onready var textoMana: Label = $TextoMana

func _ready() -> void:
	# A tela conecta o ouvido ao sinal de mana do Autoload (No futuro próximo)
	DadosJogador.manaAlterada.connect(atualizarInterface)
	
	# Puxa o valor inicial para não começar a fase com o texto vazio
	atualizarInterface(DadosJogador.manaAtual, DadosJogador.manaMaxima)

func atualizarInterface(manaAtual: int, manaMaxima: int) -> void:
	if textoMana != null:
		textoMana.text = str(manaAtual) + "/" + str(manaMaxima)
		
		if manaAtual == 0:
			textoMana.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
		else:
			textoMana.remove_theme_color_override("font_color")
