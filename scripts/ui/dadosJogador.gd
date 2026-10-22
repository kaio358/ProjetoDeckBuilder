extends Node

# Sinais para avisar a interface quando a vida mudar ou o jogador morrer
# Pelo que eu entendi, o 'signal' é um "grito" que este script vai dar para o jogo inteiro.
# Ele não quer saber quem está ouvindo, ele apenas grita: "Ei, a interface mudou! Aqui estão os novos números!"
signal interfaceAlterada(vidaAtual, vidaMaxima,armaduraAtual)
signal jogadorMorreu
signal manaAlterada(manaAtual, manaMaxima)

# Status e vida do jogador
@export var vidaMaxima: int = 80
var vidaAtual: int
var armaduraAtual: int = 0

# Combos das cartas ( combos das ruas haha)
var bonusSoma: int = 0
var bonusMultiplicador: int = 1

# Para mana
@export var manaMaxima: int = 3
var manaAtual: int


# 1 = Floresta, 2 = Vila, 3 = Castelo
var faseDesbloqueada: int = 1

func _ready() -> void:
	# Começa a run com vida cheia
	vidaAtual = vidaMaxima
	
	manaAtual = manaMaxima
	
# Reseta a vida para o início de uma nova campanha/run
func resetarParaNovaRun() -> void:
	vidaAtual = vidaMaxima
	armaduraAtual = 0
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)

# No começo de cada turno do jogador, a armadura do turno passado zera
func iniciarNovoTurno() -> void:
	armaduraAtual = 0
	manaAtual = manaMaxima
	# Eu acho que o '.emit()' é o momento exato em que ele solta o grito avisando que a armadura zerou.
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)
	# Na teoria, este grito atualiza a interface visual no começo do turno para "3/3"
	manaAlterada.emit(manaAtual, manaMaxima)

func ganharArmadura(quantidade: int) -> void:
	armaduraAtual += quantidade
	print("Arthur levantou o escudo! +", quantidade, " de armadura.")
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)

func receberDano(dano: int) -> void:
	var danoRestante = dano
	
	# Bate no escudo primeiro (exatamente igual ao monstro!)
	if armaduraAtual > 0:
		if danoRestante >= armaduraAtual:
			danoRestante -= armaduraAtual
			armaduraAtual = 0
		else:
			armaduraAtual -= danoRestante
			danoRestante = 0
			
	# Se sobrou dano, tira da vida
	if danoRestante > 0:
		vidaAtual -= danoRestante
		if vidaAtual < 0:
			vidaAtual = 0
			
		print("Arthur recebeu ", danoRestante, " de dano direto!")
		
		if vidaAtual == 0:
			print("GAME OVER: Arthur foi derrotado!")
			jogadorMorreu.emit()

	# Avisa a tela para atualizar os números
	# Grita de novo para a tela se atualizar após tomar uma pancada.
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)
	
	if vidaAtual <= 0:
		vidaAtual = 0
		interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)
		
		# Procura a cena principal atual do jogo e chama a derrota
		get_tree().current_scene.mostrarDerrota()
	
	
func curar(quantidade: int) -> void:
	vidaAtual += quantidade
	if vidaAtual > vidaMaxima:
		vidaAtual = vidaMaxima
		
	print("Arthur curou ", quantidade, " de HP! Vida atual: ", vidaAtual)
	interfaceAlterada.emit(vidaAtual, vidaMaxima,armaduraAtual)
	
# Literalmente ao gastar mana, será descontado da folha de pagamento haha
func tentarGastarMana(custo: int) -> bool:
	if manaAtual >= custo:
		manaAtual -= custo
		print("Arthur gastou ", custo, " de mana. Restam: ", manaAtual)
		manaAlterada.emit(manaAtual, manaMaxima)
		return true
	else:
		print("Sem energia! Mana insuficiente para jogar esta carta.")
		return false

	
# Para o combo

func adicionarSoma(valor: int) -> void:
	bonusSoma += valor
	# Na teoria, isso acumula pontos extras que serão somados no próximo ataque.
	print("Combo! Próximo ataque terá +", bonusSoma, " de dano.")

func adicionarMultiplicador(valor: int) -> void:
	bonusMultiplicador *= valor
	# Se a lógica não me engana, isso vai dobrar ou triplicar o estrago final.
	print("Combo! Próximo ataque será multiplicado por x", bonusMultiplicador)


func calcularEfeitoComCombo(valorBase: int) -> int:
	
	
	# Depois que o golpe acontece, o combo descarrega e volta ao normal
	var valorFinal = (valorBase + bonusSoma) * bonusMultiplicador
	
	# Depois que o efeito acontece, o combo descarrega e volta ao normal
	bonusSoma = 0
	bonusMultiplicador = 1
	
	return valorFinal
	
