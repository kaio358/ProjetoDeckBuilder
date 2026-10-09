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
func executarEfeito() -> void:
	# Um 'switch case' (match no Godot) para rodar o suporte certo
	match subTipoMagia:
		"cura":
			print("Brilho verde! O jogador curou ", poderMagico, " de HP.")
			# logicaDeCurarJogador(poderMagico)
		"buff_ataque":
			print("Aura vermelha! O próximo ataque ganha +", poderMagico, " de dano.")
			# logicaDeBuff(poderMagico)
		"comprar_carta":
			print("Visão de jogo! O jogador compra ", poderMagico, " cartas novas.")
			# logicaDeComprar(poderMagico)
		_:
			print("Efeito de magia desconhecido!")
