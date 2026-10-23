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
			"poder": 12,
			"caminho_imagem": "res://sprites/cartas_imagens/cavaleiro-removebg-preview.png"
		}
	],
	"defesa": [
		{
			"tipo": "magia", 
			"subtipo": "defesa",
			"nome": "Defesa",
			"custo": 1,
			"texto": "Ganha 5 de armadura",
			"poder": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/cavaleiro-removebg-preview.png"
		}
	],
	"combos": [
		{
			"tipo": "magia",
			"subtipo": "soma",
			"nome": "Soma",
			"custo": 2,
			"texto": "Soma +15 à próxima carta",
			"poder": 15,
			"caminho_imagem": "res://sprites/cartas_imagens/cavaleiro-removebg-preview.png"
		},
		{
			"tipo": "magia",
			"subtipo": "soma",
			"nome": "Soma +5",
			"custo": 1,
			"texto": "Soma +5 à próxima carta",
			"poder": 5,
			"caminho_imagem": "res://sprites/cartas_imagens/cavaleiro-removebg-preview.png"
		}
	]
}
