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
		"subtracao":
			# Aciona a redução de custo de mana para a próxima carta
			DadosJogador.adicionarSubtracao(poderMagico)
		"divisao":
			# Aciona a divisão de dano para o próximo ataque inimigo
			DadosJogador.adicionarDivisao(poderMagico)
		"potencia":
			# aplica o multiplicador para simular a potenciação (x²) no combo
			DadosJogador.adicionarMultiplicador(poderMagico)
		"porcentagem":
			# calcula 25% da vida máxima de Arthur (int evita número decimal)
			var curaPorcentagem = int(DadosJogador.vidaMaxima * 0.25)
			DadosJogador.curar(curaPorcentagem)
		"raiz":
			# O call_group avisa todos os inimigos para rodarem a função de debuff
			get_tree().call_group("inimigo", "sofrerDebuff", "raiz", poderMagico)
			print("Visão matemática! Raiz quadrada aplicada na defesa.")
			
		_:
			print("Efeito de magia desconhecido!")
