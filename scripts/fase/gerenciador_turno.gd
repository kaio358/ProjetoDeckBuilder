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
	# maoJogador.connect(...) É o exato equivalente ao addEventListener
	# "carta_jogada", ...) nome do evento (o grito) que queremos escutar
	# Callable é só a forma chique do Godot 4 dizer "Chame esta função"
	if not maoJogador.is_connected("carta_jogada", Callable(self, "_on_carta_jogada_na_mesa")):
		# Se não estiver conectado, faz favor de conectar
		maoJogador.connect("carta_jogada", Callable(self, "_on_carta_jogada_na_mesa"))
		
	iniciarTurnoJogador()

func iniciarTurnoJogador() -> void:
	faseAtual = FasesDoTurno.INICIO_TURNO
	
	# Puxa cartas ATÉ completar 5 na mão. 
	# Se faltam 4 no baralho, ele puxa as 4, embaralha o cemitério, e puxa mais 1.
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
		if is_instance_valid(inimigo) and inimigo.has_method("atacarJogador"):
			print("Inimigo ", inimigo.name, " está atacando!")
			inimigo.atacarJogador()
			
			# Pausa dramática de 1 segundo para o jogador ver a animação
			await get_tree().create_timer(1.0).timeout
			
	# Após todos os inimigos atacarem, passa a vez de volta para o jogador
	iniciarTurnoJogador()



# demais funções para auxiliar 

func _on_carta_jogada_na_mesa(dados_da_carta: Dictionary) -> void:
	print("Carta jogada! Enviando para o cemitério: ", dados_da_carta["nome"])
	
	# Envia diretamente para a pilha de descarte do Deck
	deckJogador.enviar_para_descarte(dados_da_carta)
