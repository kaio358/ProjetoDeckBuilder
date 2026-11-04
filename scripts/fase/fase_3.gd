extends FasePadrao


func _ready() -> void:
	GerenciadorMusica.tocarMusica(load("res://efeitosSonoros/bloomTownOst_Ignite.mp3"))

func mostrarVitoria() -> void:
	print("PASSO 3 FINAL: O Lorde Demônio caiu!")
	telaFim.show()
	textoFinal.text = "PARABÉNS!\nVocê derrotou o Lorde Demônio e salvou o reino!"
	textoFinal.add_theme_color_override("font_color", Color.GOLD)
	get_tree().paused = true

func _on_botao_continuar_pressed() -> void:
	get_tree().paused = false
	
	# Como é o chefe final, se o jogador ganhou, o jogo acaba!
	# Vamos mandar ele direto para o menu principal
	get_tree().change_scene_to_file("res://cenas/MenuPrincipal.tscn")
