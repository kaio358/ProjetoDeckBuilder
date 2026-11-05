extends Node



# Pense num banco de dados ou JSON, eu prefiro pensar no JSON
var catalogo: Dictionary = {
	"ataque": [
		{
			"tipo": "ataque",
			"subtipo": "Ataque",
			"nome": "Ataque Duplo",
			"custo": 2,
			"texto": "Causa 6x2 de dano, equivalente a 12 de dano",
			"dano": 12,
			"caminho_imagem": "res://sprites/cartas_imagens/ataqueDuplo.jpeg"
		},
		{
			"tipo": "ataque",
			"subtipo": "roubo_vida",
			"nome": "Golpe Vampírico",
			"custo": 2,
			"texto": "Causa 8 de dano. Cura 25% do dano final em vida.",
			"dano": 8,
			"caminho_imagem": "res://sprites/cartas_imagens/rouboDeVida.jpeg"
		},
		{
			"tipo": "ataque",
			"subtipo": "fracionado",
			"nome": "Corte Fracionado",
			"custo": 2,
			"texto": "Causa 6 de dano e divide (÷2) o próximo ataque inimigo.",
			"dano": 6,
			"caminho_imagem": "res://sprites/cartas_imagens/corteFracionado.jpeg"
		},
		{
			"tipo": "ataque",
			"subtipo": "ataque_escudo",
			"nome": "Golpe com Escudo",
			"custo": 1,
			"texto": "Causa 8 de dano e ganha 8 de armadura.",
			"dano": 8,
			"poder": 8,
			"caminho_imagem": "res://sprites/cartas_imagens/ataqueDeEscudo.jpeg"
		},
		{
			"tipo": "ataque",
			"subtipo": "ataque_final",
			"nome": "Golpe Final",
			"custo": 1,
			"texto": "Causa 3 de dano. Dobra (x2) para cada carta jogada neste turno (conta essa carta também).",
			"dano": 3,
			"caminho_imagem": "res://sprites/cartas_imagens/ataqueFinal.jpeg"
		},
		{
			"tipo": "ataque",
			"subtipo": "subtracao_inimigo",
			"nome": "Corte Negativo",
			"custo": 0,
			"texto": "Causa 3 de dano e reduz -6 do ataque/defesa inimigo.",
			"dano": 3,
			"poder": 6,
			"caminho_imagem": "res://sprites/cartas_imagens/corteNegativo.jpeg"
		}
	],
	"defesa": [
		{
			"tipo": "magia", 
			"subtipo": "defesa",
			"nome": "Defesa +15 ",
			"custo": 1,
			"texto": "Ganha 15 de armadura",
			"poder": 15,
			"caminho_imagem": "res://sprites/cartas_imagens/defesa+15.jpeg"
		}
	],
	"combos": [
		{
			"tipo": "magia",
			"subtipo": "soma",
			"nome": "Soma +15",
			"custo": 2,
			"texto": "Soma +15 à próxima carta",
			"poder": 15,
			"caminho_imagem": "res://sprites/cartas_imagens/soma+15.jpeg"
		},
		{
			"tipo": "magia",
			"subtipo": "soma",
			"nome": "Soma +5",
			"custo": 1,
			"texto": "Soma +5 à próxima carta",
			"poder": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/soma.jpeg"
		},
		{
			"tipo": "magia",
			"subtipo": "potencia",
			"nome": "Potenciação (x²)",
			"custo": 2,
			"texto": "Eleva ao quadrado (x²) o valor base do próximo golpe.",
			"poder": 2,
			"caminho_imagem": "res://sprites/cartas_imagens/potencia.jpeg"
		}
	],
	"cura": [
		 {
			"tipo": "magia",
			"subtipo": "cura",
			"nome": "Poção ",
			"custo": 1,
			"texto": "Cura +10",
			"poder": 10,
			"caminho_imagem": "res://sprites/cartas_imagens/cura+10.jpeg"
		},
		{
			"tipo": "magia",
			"subtipo": "porcentagem",
			"nome": "Porcentagem (25%)",
			"custo": 2,
			"texto": "Cura 25% da vida máxima de Arthur (20 HP).",
			"poder": 20,
			"caminho_imagem": "res://sprites/cartas_imagens/curaPorcentagem.jpeg"
		}
		],
	"utilitarias": [
		# Espero que funcione
		{
			"tipo": "magia",
			"subtipo": "raiz",
			"nome": "Raiz Quadrada (√x)",
			"custo": 1,
			"texto": "Extrai a raiz da armadura inimiga (Reduz em 50%).",
			"poder": 2,
			"caminho_imagem": "res://sprites/cartas_imagens/raiz.jpeg"
		}
	]
		
	
}
