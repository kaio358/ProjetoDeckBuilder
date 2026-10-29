extends FasePadrao

func mostrarVitoria() -> void:
	# Ignora a lógica de instanciar a Tela de Recompensa
	# e devolve o jogador direto para o Menu Principal
	get_tree().change_scene_to_file("res://cenas/MenuPrincipal.tscn")
