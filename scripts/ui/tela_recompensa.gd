extends Control

# Cennas
const CartaAtaque = preload("res://cenas/cartas/cardPadraoAtaque.tscn")
const CartaMagia = preload("res://cenas/cartas/cardPadraoMagia.tscn")

@onready var containerCartas: HBoxContainer = $HBoxContainer

func _ready() -> void:
	var piscinaDeCartas: Array[Dictionary] = []
	
	# Percorre todos os tópicos e junta tudo numa lista só
	for categoria in BancoDeCartas.catalogo.values():
		piscinaDeCartas.append_array(categoria)
		
	# Embaralha e pega as 3 primeiras
	piscinaDeCartas.shuffle()
	var cartasSorteadas = piscinaDeCartas.slice(0, 3)
	
	for carta in cartasSorteadas:
		criarBotaoCarta(carta)

func criarBotaoCarta(dadosDaCarta: Dictionary) -> void:
	var botao = TextureButton.new()
	botao.custom_minimum_size = Vector2(150, 220) # Tamanho base da sua carta
	
	var cenaVisual
	if dadosDaCarta["tipo"] == "ataque":
		cenaVisual = CartaAtaque.instantiate()
	else:
		cenaVisual = CartaMagia.instantiate()
	
	
	# Adiciona a carta dentro do botão, e o botão no container
	botao.add_child(cenaVisual)
	containerCartas.add_child(botao)
	
	# ajustando o tamanho
	var escalaNormal = Vector2(0.3, 0.3)
	# O tamanho quando o mouse passa por cima (um pouco maior)
	var escalaHover = Vector2(0.35, 0.35)
	
	cenaVisual.transformarEmVitrine(escalaNormal.x)
	
	# Chama a função existente na sua carta que preenche nomes, custos e imagens
	cenaVisual.configurar(dadosDaCarta)
	
	botao.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(cenaVisual, "scale", escalaHover, 0.15)
	)
	
	botao.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(cenaVisual, "scale", escalaNormal, 0.15)
	)
	
	botao.pressed.connect(func(): _on_carta_escolhida(dadosDaCarta))
	
	

func _on_carta_escolhida(carta: Dictionary) -> void:
	# Ajuste 'baralhoGlobal' para o nome real da variável do seu baralho no Autoload
	DadosJogador.baralhoGlobal.append(carta) 
	
	get_tree().change_scene_to_file("res://cenas/ui/mapa_de_rotas.tscn")
