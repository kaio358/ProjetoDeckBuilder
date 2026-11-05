extends Node

# Sinais para avisar a interface quando a vida mudar ou o jogador morrer
# Pelo que eu entendi, o 'signal' é um "grito" que este script vai dar para o jogo inteiro.
# Ele não quer saber quem está ouvindo, ele apenas grita: "Ei, a interface mudou! Aqui estão os novos números!"
signal interfaceAlterada(vidaAtual, vidaMaxima, armaduraAtual)
signal jogadorMorreu
signal manaAlterada(manaAtual, manaMaxima)

# Status e vida do jogador
@export var vidaMaxima: int = 80
var vidaAtual: int
var armaduraAtual: int = 0
var cartasJogadasNoTurno: int = 0

# Armazenar o baralho do individuo
var baralhoGlobal: Array[Dictionary] = []

# Combos das cartas ( combos das ruas haha)
var bonusSoma: int = 0
var bonusMultiplicador: int = 1
var bonusPotencia: int = 1
# Novas variáveis para os testes de subtração e divisão
var descontoManaSubtracao: int = 0  # acho que isso guarda o desconto de mana
var divisorDanoRecebido: int = 1    # para dividir o dano que o inimigo der

# Para mana
@export var manaMaxima: int = 3
var manaAtual: int

# 1 = Floresta, 2 = Vila, 3 = Castelo
var faseDesbloqueada: int = 1

func _ready() -> void:
	# Começa a run com vida cheia
	vidaAtual = vidaMaxima
	
	manaAtual = manaMaxima
	
	_inicializar_deck()

# Inicializa o deck com cartas de teste variadas (mantemos igual, mas testando balanceamento)
func _inicializar_deck() -> void:
	# Ataque
	for i in range(3):
		# Mais tarde coloco a parte de imagem, vai dar trabalho
		var cartaAtaque = {
			"tipo": "ataque",
			"nome": "Ataque " + str(i + 1),
			"custo": 1,
			"texto": "Causa 5 de dano direto",
			"dano": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/ataque.jpeg"
		}
		baralhoGlobal.append(cartaAtaque)
	for i in range(1):
		var cartaAtaque = {
			"tipo": "ataque",
			"nome": "Golpe Rápido",
			"custo": 0,
			"texto": "Causa 3 de dano direto por custo 0.",
			"dano": 3,
			"caminho_imagem": "res://sprites/cartas_imagens/ataqueRapido.jpeg"
		}
		baralhoGlobal.append(cartaAtaque)
	
	for i in range(1):
		var cartaAtaque = {
			"tipo": "ataque",
			"nome": "Investida Pesada",
			"custo": 2,
			"texto": "Causa 10 de dano direto pesado.",
			"dano": 10,
			"caminho_imagem": "res://sprites/cartas_imagens/investidaPesada.jpeg"
		}
		baralhoGlobal.append(cartaAtaque)
		
	# Defesa
	for i in range(3):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "defesa",
			"nome": "Defesa " + str(i + 1),
			"custo": 1,
			"texto": "Ganha 5 de armadura",
			"poder": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/defesa.jpeg"
		}
		baralhoGlobal.append(cartaMagia)

	# Soma
	for i in range(2):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "soma",
			"nome": "Soma " + str(i + 1),
			"custo": 1, # abaixei o custo pra valer a pena
			"texto": "Soma +5 à próxima carta",
			"poder": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/soma.jpeg"
		}
		baralhoGlobal.append(cartaMagia)
		
	# Multiplicação 
	for i in range(2):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "multiplicacao",
			"nome": "Multiplicação " + str(i + 1),
			"custo": 1, # deixei 1 pra ser util contra o boss
			"texto": "Multiplica (X2) a próxima carta",
			"poder": 2,
			"caminho_imagem": "res://sprites/cartas_imagens/multiplicacao.jpeg"
		}
		baralhoGlobal.append(cartaMagia)

	# Subtração 
	for i in range(1):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "subtracao",
			"nome": "Subtração " + str(i + 1),
			"custo": 0, # zero mana porque ele desconta a próxima
			"texto": "Subtrai 1 de mana da próxima carta",
			"poder": 1,
			"caminho_imagem": "res://sprites/cartas_imagens/subtracao.jpeg"
		}
		baralhoGlobal.append(cartaMagia)
		
	# Divisão
	for i in range(1):
		var cartaMagia = {
			"tipo": "magia",
			"subtipo": "divisao",
			"nome": "Divisão " + str(i + 1),
			"custo": 1,
			"texto": "Divide o ataque inimigo por 2",
			"poder": 2,
			"caminho_imagem": "res://sprites/cartas_imagens/divisao.jpeg"
		}
		baralhoGlobal.append(cartaMagia)

# Reseta a vida para o início de uma nova campanha/run
func resetarParaNovaRun() -> void:
	vidaAtual = vidaMaxima
	armaduraAtual = 0
	faseDesbloqueada = 1 # trava o mapa de novo pra não bugar
	_resetarCombos() # zera as contas matemáticas pra garantir
	baralhoGlobal.clear()
	_inicializar_deck()
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)

# No começo de cada turno do jogador, a armadura do turno passado zera
func iniciarNovoTurno() -> void:
	armaduraAtual = 0
	manaAtual = manaMaxima
	bonusSoma = 0
	bonusMultiplicador = 1
	cartasJogadasNoTurno = 0
	
	_resetarCombos()
	# Eu acho que o '.emit()' é o momento exato em que ele solta o grito avisando que a armadura zerou.
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)
	# Na teoria, este grito atualiza a interface visual no começo do turno para "3/3"
	manaAlterada.emit(manaAtual, manaMaxima)

func ganharArmadura(quantidade: int) -> void:
	armaduraAtual += quantidade
	print("Arthur levantou o escudo! +", quantidade, " de armadura.")
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)

func receberDano(dano: int) -> void:
	# Pelo que entendi, primeiro divide o dano se o jogador usou a carta de divisão
	var danoReal = dano / divisorDanoRecebido
	divisorDanoRecebido = 1 # quebra o escudo de divisão para o próximo turno
	
	var danoRestante = danoReal
	
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
	interfaceAlterada.emit(vidaAtual, vidaMaxima, armaduraAtual)
	
# Literalmente ao gastar mana, será descontado da folha de pagamento haha
func tentarGastarMana(custoOriginal: int) -> bool:
	# acho que max() não deixa o custo ficar negativo se tiver muito desconto, senão ia dar mana de graça kkk
	var custoFinal = max(0, custoOriginal - descontoManaSubtracao)
	
	if manaAtual >= custoFinal:
		manaAtual -= custoFinal
		cartasJogadasNoTurno += 1
		descontoManaSubtracao = 0 # se gastou a mana, o desconto descarrega e some
		print("Arthur gastou ", custoFinal, " de mana. Restam: ", manaAtual)
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

func adicionarSubtracao(valor: int) -> void:
	descontoManaSubtracao += valor
	# tô testando esse print pra ver se o combo da subtração dá certo
	print("Combo! Próxima carta custará -", descontoManaSubtracao, " de mana.")

func adicionarDivisao(valor: int) -> void:
	divisorDanoRecebido *= valor
	print("Defesa Matemática! Próximo ataque inimigo será dividido por ÷", divisorDanoRecebido)
	
	# O call_group é um megafone do Godot!
	# Ele procura todo mundo que está no grupo "inimigo" no cenário
	# e manda eles rodarem a função "atualizarTextoIntencao" imediatamente.
	get_tree().call_group("inimigo", "atualizarTextoIntencao")

func adicionarPotencia(valor: int) -> void:
	bonusPotencia = valor

func _resetarCombos() -> void:
	# limpa tudo que é matemática caso inicie uma nova run pra não vazar combo antigo
	bonusSoma = 0
	bonusMultiplicador = 1
	descontoManaSubtracao = 0
	divisorDanoRecebido = 1

func calcularEfeitoComCombo(valorBase: int) -> int:
	# Depois que o golpe acontece, o combo descarrega e volta ao normal
	var valorElevado = int(pow(valorBase, bonusPotencia))
	var valorFinal = (valorElevado * bonusMultiplicador  + bonusSoma)
	
	# Depois que o efeito acontece, o combo descarrega e volta ao normal
	bonusSoma = 0
	bonusMultiplicador = 1
	
	return valorFinal
