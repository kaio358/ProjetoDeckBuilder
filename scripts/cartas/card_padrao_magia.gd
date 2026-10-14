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
# Adicionamos o '(alvo: Node2D)' aqui para não quebrar a regra do pai!
func executarEfeito(_alvo: Node2D) -> void:
	match subTipoMagia:
		"cura":
			# Cura ignora o alvo inimigo e foca no jogador
			print("Brilho verde! O jogador curou ", poderMagico, " de HP.")
		"buff_ataque":
			print("Aura vermelha! O próximo ataque ganha +", poderMagico, " de dano.")
		"comprar_carta":
			print("Visão de jogo! O jogador compra ", poderMagico, " cartas novas.")
		_:
			print("Efeito de magia desconhecido!")
