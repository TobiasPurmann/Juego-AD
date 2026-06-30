extends Node
class_name BarrelHealth

# Señales para avisar a la interfaz y al juego cuando algo cambia
signal vida_cambiada(vida_actual: int)
signal barril_destruido

@export var vida_maxima: int = 50
var vida_actual: int = 0

func _ready() -> void:
	# Al iniciar, el barril empieza con su vida al máximo
	vida_actual = vida_maxima
	# Avisamos el valor inicial
	emit_signal("vida_cambiada", vida_actual)

func recibir_daño(cantidad: int) -> void:
	if vida_actual <= 0: return
	
	vida_actual -= cantidad
	# Emitimos la señal con la nueva vida para que el texto se entere en tiempo real
	emit_signal("vida_cambiada", vida_actual)
	
	if vida_actual <= 0:
		morir()

func morir() -> void:
	emit_signal("barril_destruido")
	# Destruye el barril completo (el nodo padre de este componente)
	get_parent().queue_free()
