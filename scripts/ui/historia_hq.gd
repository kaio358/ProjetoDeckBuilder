extends Control

# Caminho para onde o jogo vai ao pular ou terminar a cena
const MAPA_DE_ROTAS = "res://cenas/ui/mapa_de_rotas.tscn"

@onready var imagemHQ: TextureRect = $ImagemHQ

func _ready() -> void:
	# Efeito visual opcional: faz a HQ aparecer com um Fade-in suave
	imagemHQ.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(imagemHQ, "modulate:a", 1.0, 0.5)

# O _input pega QUALQUER evento de teclado, mouse ou controle
func _input(event: InputEvent) -> void:
	# Verifica oque foi pressionado
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		pularCena()

func pularCena() -> void:
	# Só para os inputs não chamar para troca de cena duas vezes sem querer
	set_process_input(false)
	get_tree().change_scene_to_file(MAPA_DE_ROTAS)
