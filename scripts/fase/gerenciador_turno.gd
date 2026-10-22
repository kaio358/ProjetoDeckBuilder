extends Node
class_name GerenciadorTurno

enum FasesDoTurno {
	INICIO_TURNO,
	ACOES_JOGADOR,
	FIM_TURNO,
	TURNO_INIMIGO
}

var faseAtual: FasesDoTurno = FasesDoTurno.INICIO_TURNO

@export_category("Conexões")
@export var maoJogador: Mao
@export var deckJogador: Deck
@export var baralhoVisual: BaralhoBatalha

func _ready() -> void:
	# Espera a cena terminar de carregar antes de iniciar o turno.
	call_deferred("_iniciarCombate")

func _iniciarCombate() -> void:
	print("--- INICIANDO COMBATE ---")
	if baralhoVisual != null:
		baralhoVisual.configurar(deckJogador)
		
	# O Gerenciador passa a escutar quando a mão "jogar" uma carta
	if not maoJogador.is_connected("carta_jogada", Callable(self, "_on_carta_jogada_na_mesa")):
		maoJogador.connect("carta_jogada", Callable(self, "_on_carta_jogada_na_mesa"))
		
	iniciarTurnoJogador()

func iniciarTurnoJogador() -> void:
	faseAtual = FasesDoTurno.INICIO_TURNO
	
	# Zera armadura do jogador
	DadosJogador.iniciarNovoTurno()
	
	# Puxa cartas ATÉ completar 5 na mão. 
	while maoJogador.cartas_na_mao.size() < 5:
		var novaCarta = deckJogador.comprar_carta()
		if novaCarta.is_empty():
			break
		maoJogador.adicionar_carta(novaCarta)
		
	# Atualiza o número visual na tela apenas DEPOIS de puxar as cartas
	if baralhoVisual != null:
		baralhoVisual.atualizar_visual()
		
	faseAtual = FasesDoTurno.ACOES_JOGADOR

func passarTurno() -> void:
	if faseAtual != FasesDoTurno.ACOES_JOGADOR:
		return

	faseAtual = FasesDoTurno.FIM_TURNO

	# Limpa a mão e envia as cartas que sobraram para o CEMITÉRIO (descarte)
	var cartasSobrantes = maoJogador.descartar_mao()
	for carta in cartasSobrantes:
		deckJogador.enviar_para_descarte(carta)

	iniciarTurnoInimigo()

func iniciarTurnoInimigo() -> void:
	faseAtual = FasesDoTurno.TURNO_INIMIGO
	print("--- TURNO DO INIMIGO COMEÇOU ---")
	
	# Pega todas as áreas do grupo 'inimigo' na cena
	var areasInimigos = get_tree().get_nodes_in_group("inimigo")
	
	for area in areasInimigos:
		var inimigo = area.get_parent()
		
		# Verifica se o inimigo ainda está vivo e tem a função de ataque
		if is_instance_valid(inimigo) and inimigo.has_method("executarAcaoTurno"):
			inimigo.executarAcaoTurno()
			
			# Pausa dramática de 1 segundo para o jogador ver a animação de CADA orc agir
			await get_tree().create_timer(1.0).timeout
			# Após atacar o inimigo planeja na sua próximo turno
			if inimigo.has_method("planejarProximoTurno"):
				inimigo.planejarProximoTurno()
				
	# Após todos os inimigos atacarem, passa a vez de volta para o jogador
	iniciarTurnoJogador()

func _on_carta_jogada_na_mesa(dados_da_carta: Dictionary) -> void:
	print("Carta jogada! Enviando para o cemitério: ", dados_da_carta["nome"])
	deckJogador.enviar_para_descarte(dados_da_carta)
