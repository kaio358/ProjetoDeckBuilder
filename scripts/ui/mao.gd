extends Node2D
class_name Mao

@export_category("Tamanho Padrão")
@export var largura_alvo_carta: float = 170.0
@export var altura_alvo_carta: float = 242.0

@export_category("Configurações de Layout")
@export var espacamento_maximo: float = 120.0
@export var largura_maxima_mao: float = 600.0
@export var altura_arco_y: float = 18.0          # Curvatura vertical nas pontas
@export var inclinacao_maxima_deg: float = 8.0   # Ângulo de rotação nas pontas

@export_category("Recursos")
@export var cenaBaseAtaque: PackedScene
@export var cenaBaseMagia: PackedScene

var cartas_na_mao: Array = []

# tipo o que fazemos no JS : document.getElementById("botao").addEventListener("click", minhaFuncao)
signal carta_jogada(dados_da_carta)
# Adiciona uma nova carta à mão
func adicionar_carta(dados_carta) -> void:
	
	var tipoCarta = dados_carta.get("tipo", "ataque")
	var cenaCorreta: PackedScene
	
	match tipoCarta:
		"ataque":
			cenaCorreta = cenaBaseAtaque
		"magia":
			cenaCorreta = cenaBaseMagia
		_:
			cenaCorreta = cenaBaseAtaque
			
	if cenaCorreta == null:
		push_error("ERRO [Mao]: A cena base do tipo '" + tipoCarta + "' não foi vinculada no Inspetor!")
		return

	var nova_carta = cenaCorreta.instantiate()
	add_child(nova_carta)
	
	nova_carta.connect("foi_jogada", Callable(self, "processar_jogada"))
	
	if nova_carta == null:
		push_error("ERRO [Mao]: Falha ao instanciar 'cena_carta'.")
		return

	

	if nova_carta.has_method("configurar"):
		nova_carta.configurar(dados_carta)

	redimensionar_carta(nova_carta)
	# Armazena os dados na própria carta para resgate posterior
	nova_carta.set_meta("dados_carta", dados_carta)

	cartas_na_mao.append(nova_carta)
	reorganizar_mao()
	
# Limpa e descarta todas as cartas no fim do turno retornando apenas os DADOS das cartas
func descartar_mao() -> Array:
	var dados_descartados = []
	
	for carta in cartas_na_mao:
		if is_instance_valid(carta):
			if carta.has_meta("dados_carta"):
				dados_descartados.append(carta.get_meta("dados_carta"))
			carta.queue_free()
		
	cartas_na_mao.clear()
	
	return dados_descartados


func processar_jogada(carta_node: Node2D) -> void:
	# Pega os dados que salvamos nela quando ela foi criada
	var dados = carta_node.get_meta("dados_carta")
	
	# Avisa o mundo que a carta foi jogada
	carta_jogada.emit(dados)
	
	# Remove a carta da lista da mão
	cartas_na_mao.erase(carta_node)
	
	# Destrói o visual da carta
	carta_node.queue_free()
	
	# Reorganiza o leque com as cartas que sobraram
	reorganizar_mao()

# Reorganiza posições, curvatura Y e rotação
func reorganizar_mao() -> void:
	var total = cartas_na_mao.size()
	if total == 0:
		return

	var espacamento = espacamento_maximo
	if (total - 1) * espacamento > largura_maxima_mao:
		espacamento = largura_maxima_mao / float(total - 1)

	var largura_total = (total - 1) * espacamento
	var inicio_x = -largura_total / 2.0

	for i in range(total):
		var carta = cartas_na_mao[i]

		var fator_centro = 0.0
		if total > 1:
			fator_centro = (float(i) / float(total - 1)) * 2.0 - 1.0

		var x = inicio_x + (i * espacamento)
		var y = abs(fator_centro) * altura_arco_y
		var rot_rad = deg_to_rad(fator_centro * inclinacao_maxima_deg)

		var posicao_alvo = Vector2(x, y)

		carta.position = posicao_alvo
		carta.rotation = rot_rad
	
	
# Como a carta original pode ter qualquer tamanho, fazemos uma
# conta para ela ficar com um tamanho padrão na mão.
func redimensionar_carta(carta: Node2D) -> void:
	# Busca o Sprite2D que serve de fundo/base para a carta
	var spriteBase: Sprite2D = carta.get_node_or_null("CardBase")
	
	if spriteBase == null or spriteBase.texture == null:
		push_warning("Aviso: 'CardBase' não encontrado ou sem textura na carta " + carta.name)
		return
	
	var tamanhoOriginal = spriteBase.texture.get_size()
	
	if tamanhoOriginal.x <= 0 or tamanhoOriginal.y <= 0:
		return
	
	# Calcula a matemática da proporção
	var escalaX = largura_alvo_carta / tamanhoOriginal.x
	var escalaY = altura_alvo_carta / tamanhoOriginal.y
	
	# Aplica a escala na CARTA INTEIRA (textos, área de colisão e imagem vão diminuir juntos)
	carta.scale = Vector2(escalaX, escalaY)
