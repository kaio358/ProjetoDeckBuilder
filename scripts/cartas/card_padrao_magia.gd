extends CartaBase 
class_name CardPadraoMagia

@export var subTipoMagia: String = "cura" # Pode ser "cura", "buff_ataque", "comprar_carta"
@export var poderMagico: int = 5

# Complementa a função configurar do Pai
func _configurarExtra(dadosCarta: Dictionary) -> void:
	if dadosCarta.has("subtipo"):
		subTipoMagia = dadosCarta["subtipo"]
	if dadosCarta.has("poder"):
		poderMagico = dadosCarta["poder"]

# Sobrescreve a função de efeito focada em suporte

func executarEfeito(_alvo: Node2D) -> void:
	match subTipoMagia:
		"cura":
			var curaReal = DadosJogador.calcularEfeitoComCombo(poderMagico)
			print("Brilho verde! O jogador curou ", curaReal, " de HP com combos.")
			DadosJogador.curar(curaReal)
		"defesa":
			var defesaReal = DadosJogador.calcularEfeitoComCombo(poderMagico)
			DadosJogador.ganharArmadura(defesaReal)
		"buff_ataque":
			print("Aura vermelha! O próximo ataque ganha +", poderMagico, " de dano.")
		"comprar_carta":
			print("Visão de jogo! O jogador compra ", poderMagico, " cartas novas.")
		
		# === OS COMBOS MATEMÁTICOS ===
		"soma":
			DadosJogador.adicionarSoma(poderMagico)
		"multiplicacao":
			DadosJogador.adicionarMultiplicador(poderMagico)
		"divisao":
			# Pode ser usado como debuff no inimigo no futuro!
			pass
			
		_:
			print("Efeito de magia desconhecido!")
