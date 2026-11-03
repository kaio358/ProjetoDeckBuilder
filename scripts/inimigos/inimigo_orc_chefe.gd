extends InimigoPadrao

#Sobrescrevendo função pai
func planejarProximoTurno() -> void:
	var acaoDaVez = padraoAcoes[passoAtual]
	
	if acaoDaVez == "ataque_forte":
		proximaAcao = "ataque_forte"
		valorAcao = 30 
		
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
		print("O Orc Chefe desfere um golpe esmagador!")
		DadosJogador.receberDano(valorAcao)
	else:
		# Aciona a execução normal do pai para os outros golpes
		super()
