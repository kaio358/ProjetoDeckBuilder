extends Node

@onready var tocador: AudioStreamPlayer = $TocadorBGM

# A função recebe o arquivo de áudio e verifica se precisa tocar
func tocarMusica(novaMusica: AudioStream) -> void:
	# Se a música que pediram já é a que está tocando, não faz nada!
	# Isso impede que a música reinicie ao mudar de uma fase para outra com o mesmo som.
	if tocador.stream == novaMusica and tocador.playing:
		return 
		
	# Se for uma música nova, troca o "disco" e dá play
	tocador.stream = novaMusica
	tocador.play()

func pararMusica() -> void:
	tocador.stop()
