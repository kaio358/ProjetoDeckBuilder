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

# Sobrescreve a função de efeito para atacar
func executarEfeito() -> void:
	print("POW! A carta ", cardNome, " causou ", textoDeDano, " de dano ao inimigo!")
