extends Node

# Sinais para avisar a interface quando a vida mudar ou o jogador morrer
signal vidaAlterada(vidaAtual, vidaMaxima)
signal jogadorMorreu

@export var vidaMaxima: int = 80
var vidaAtual: int

func _ready() -> void:
	# Começa a run com vida cheia
	vidaAtual = vidaMaxima

# Reseta a vida para o início de uma nova campanha/run
func resetarParaNovaRun() -> void:
	vidaAtual = vidaMaxima
	vidaAlterada.emit(vidaAtual, vidaMaxima)

func receberDano(dano: int) -> void:
	vidaAtual -= dano
	if vidaAtual < 0:
		vidaAtual = 0
		
	print("Arthur recebeu ", dano, " de dano! Vida atual: ", vidaAtual, "/", vidaMaxima)
	vidaAlterada.emit(vidaAtual, vidaMaxima)
	
	if vidaAtual == 0:
		print("GAME OVER: Arthur foi derrotado!")
		jogadorMorreu.emit()

func curar(quantidade: int) -> void:
	vidaAtual += quantidade
	if vidaAtual > vidaMaxima:
		vidaAtual = vidaMaxima
		
	print("Arthur curou ", quantidade, " de HP! Vida atual: ", vidaAtual)
	vidaAlterada.emit(vidaAtual, vidaMaxima)
