extends Node
class_name GerenciadorTurno

# Aqui ficam as fases que o combate pode ter.
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
	call_deferred("iniciarTurnoJogador")


func iniciarTurnoJogador() -> void:
	faseAtual = FasesDoTurno.INICIO_TURNO
	print("--- TURNO DO JOGADOR COMEÇOU ---")

	# Compra cartas até completar a mão.
	while maoJogador.cartas_na_mao.size() < 5:
		var novaCarta = deckJogador.comprar_carta()

		# Se não houver mais cartas disponíveis, encerra a compra.
		if novaCarta.is_empty():
			break

		maoJogador.adicionar_carta(novaCarta)
		
	#  atualiza o número de cartas restantes
	if baralhoVisual != null:
		baralhoVisual.atualizar_visual()
		
	faseAtual = FasesDoTurno.ACOES_JOGADOR
	print("Aguardando as jogadas do jogador...")


func passarTurno() -> void:
	# Impede passar o turno quando o jogador não pode agir.
	if faseAtual != FasesDoTurno.ACOES_JOGADOR:
		return

	faseAtual = FasesDoTurno.FIM_TURNO
	print("--- FIM DO TURNO DO JOGADOR ---")

	# Descarta as cartas que sobraram na mão.
	var cartasSobrantes = maoJogador.descartar_mao()

	for carta in cartasSobrantes:
		deckJogador.enviar_para_descarte(carta)
		
		print("Cartas descartadas: ", cartasSobrantes.size())
	iniciarTurnoInimigo()


func iniciarTurnoInimigo() -> void:
	faseAtual = FasesDoTurno.TURNO_INIMIGO
	print("Turno do inimigo!")

	# Temporário: simula o tempo de ação do inimigo.
	await get_tree().create_timer(1.5).timeout

	print("O inimigo terminou sua ação.")

	# Por enquanto, retorna ao jogador.
	iniciarTurnoJogador()
