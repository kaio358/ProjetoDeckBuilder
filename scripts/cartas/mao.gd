extends Node2D
class_name Mao

@export_category("Configurações de Layout")
@export var espacamento_maximo: float = 120.0
@export var largura_maxima_mao: float = 600.0
@export var altura_arco_y: float = 18.0          # Curvatura vertical nas pontas
@export var inclinacao_maxima_deg: float = 8.0   # Ângulo de rotação nas pontas

@export_category("Recursos")
@export var cena_carta: PackedScene


var cartas_na_mao: Array = []

# Adiciona uma nova carta à mão
func adicionar_carta(dados_carta) -> void:
	# Verificação de segurança 1
	if cena_carta == null:
		push_error("ERRO [Mao]: A 'cena_carta' não foi atribuída no Inspetor do nó Mao!")
		return

	var nova_carta = cena_carta.instantiate()
	
	# Verificação de segurança 2
	if nova_carta == null:
		push_error("ERRO [Mao]: Falha ao instanciar 'cena_carta'.")
		return

	add_child(nova_carta)

	if nova_carta.has_method("configurar"):
		nova_carta.configurar(dados_carta)

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
	
