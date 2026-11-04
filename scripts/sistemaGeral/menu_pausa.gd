extends CanvasLayer

func _ready() -> void:
	hide() 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Tecla ESC nativa do Godot
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused

func _on_botao_continuar_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_botao_configuracoes_pressed() -> void:
	var telaConfig = preload("res://cenas/configuracoes.tscn").instantiate()
	add_child(telaConfig)

func _on_botao_desistir_pressed() -> void:
	get_tree().paused = false # Sempre despause o jogo antes de mudar de cena
	get_tree().change_scene_to_file("res://cenas/MenuPrincipal.tscn")
