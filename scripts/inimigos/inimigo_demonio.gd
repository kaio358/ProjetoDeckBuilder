extends InimigoPadrao

func planejarProximoTurno() -> void:
	var acaoDaVez = padraoAcoes[passoAtual]
	
	if acaoDaVez == "ataque_forte":
		proximaAcao = "ataque_forte"
		valorAcao = 50 
		
		atualizarTextoIntencao()
		
		if displayIntencao != null:
			displayIntencao.show()
			
		passoAtual = (passoAtual + 1) % padraoAcoes.size()
	else:
		super()

func executarAcaoTurno() -> void:
	if proximaAcao == "ataque_forte":
		if displayIntencao != null:
			displayIntencao.hide()
			
		armaduraAtual = 0
		atualizarInterfaceEscudo()
		
		arteInimigo.play("atacando")
		print("O Lorde Demônio lança chamas devastadoras!")
		
		# Aplica o dano massivo direto no jogador
		DadosJogador.receberDano(valorAcao)
	else:
		# Aciona a execução normal do pai para o resto
		super()
