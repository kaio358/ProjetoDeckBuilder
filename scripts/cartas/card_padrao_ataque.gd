extends CartaBase
class_name CardPadraoAtaque 

@export var textoDeDano: int = 1

# Referência que só a carta de ataque tem
@onready var labelDano: Label = $CardTexto/TextoDeDano

# Roda logo depois do _ready do Pai
func _readyCustomizado() -> void:
	labelDano.set_text(str(textoDeDano))

# Complementa a função configurar do Pai
func _configurarExtra(dadosCarta: Dictionary) -> void:
	if dadosCarta.has("dano"):
		textoDeDano = dadosCarta["dano"]
		labelDano.set_text(str(textoDeDano))

# Sobrescreve a função de efeito 
func executarEfeito(alvo: Node2D) -> void:
	# print("POW! Carta de Ataque causou ", textoDeDano, " de dano no inimigo: ", alvo.name)
	
	# Chama a função no script do Inimigo!
	if alvo.has_method("receberDano"):
		alvo.receberDano(textoDeDano)
