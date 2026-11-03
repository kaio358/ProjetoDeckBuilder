extends CartaBase
class_name CardPadraoAtaque 

@export var textoDeDano: int = 1
@export var subTipoAtaque: String = "normal"
@export var poderExtra: int = 0
# Referência que só a carta de ataque tem
@onready var labelDano: Label = $CardTexto/TextoDeDano

# Roda logo depois do _ready do Pai
func _readyCustomizado() -> void:
	labelDano.set_text(str(textoDeDano))

# Complementa a função configurar do Pai
func _configurarExtra(dadosCarta: Dictionary) -> void:
	if dadosCarta.has("dano"):
		textoDeDano = dadosCarta["dano"]
		if labelDano != null:
			labelDano.set_text(str(textoDeDano))
	if dadosCarta.has("subtipo"):
		subTipoAtaque = dadosCarta["subtipo"]
	if dadosCarta.has("poder"):
		poderExtra = dadosCarta["poder"]
		
# Sobrescreve a função de efeito 
func executarEfeito(alvo: Node2D) -> void:
	# Aplica os combos de Soma e Multiplicação acumulados no dano base
	var danoCalculado = DadosJogador.calcularEfeitoComCombo(textoDeDano)
	
	match subTipoAtaque:
		"roubo_vida":
			if alvo.has_method("receberDano"):
				alvo.receberDano(danoCalculado)
			# 25% do dano final vira cura (int() evita números decimais no HP)
			var curaRoubada = int(danoCalculado * 0.25)
			if curaRoubada > 0:
				DadosJogador.curar(curaRoubada)
				print("Roubo de vida! Curou ", curaRoubada, " de HP.")

		"fracionado":
			if alvo.has_method("receberDano"):
				alvo.receberDano(danoCalculado)
			# Aplica a divisão no próximo dano do inimigo
			DadosJogador.adicionarDivisao(2)

		"ataque_escudo":
			if alvo.has_method("receberDano"):
				alvo.receberDano(danoCalculado)
			# Ganha a armadura junto com o golpe
			DadosJogador.ganharArmadura(poderExtra)

		"ataque_final":
			# Dobra (x2) para cada carta já jogada no mesmo turno
			var multiplicador = int(pow(2, max(0, DadosJogador.cartasJogadasNoTurno - 1)))
			var danoFinal = danoCalculado * multiplicador
			if alvo.has_method("receberDano"):
				alvo.receberDano(danoFinal)
			print("Golpe Final! Cartas jogadas: ", DadosJogador.cartasJogadasNoTurno, " | Dano Total: ", danoFinal)

		"subtracao_inimigo":
			if alvo.has_method("receberDano"):
				alvo.receberDano(danoCalculado)
			# Avisa o alvo que ele também sofreu a penalidade matemática
			if alvo.has_method("sofrerDebuff"):
				alvo.sofrerDebuff("subtracao", poderExtra)
			print("Corte Negativo aplicado com sucesso no inimigo!")
			
		_: # Ataque genérico padrão
			if alvo.has_method("receberDano"):
				alvo.receberDano(danoCalculado)
