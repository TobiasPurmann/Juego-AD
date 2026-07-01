extends Node
class_name ContadorMejora

# Señales para avisar cambios a la interfaz de la compuerta
signal contador_cambiado(valor_actual: int)
signal mejora_desbloqueada

@export_category("Configuración de Mejora")
@export var cuenta_regresiva_inicial: int = 15
@export_enum("Nueva Arma", "Reclutar Aliado") var tipo_recompensa: String = "Nueva Arma"

var cuenta_actual: int = 0

func _ready() -> void:
	cuenta_actual = cuenta_regresiva_inicial
	emit_signal("contador_cambiado", cuenta_actual)

func registrar_impacto(cantidad: int) -> void:
	if cuenta_actual <= 0: return
	
	cuenta_actual -= cantidad
	emit_signal("contador_cambiado", cuenta_actual)
	
	if cuenta_actual <= 0:
		activar_recompensa()

func activar_recompensa() -> void:
	emit_signal("mejora_desbloqueada")
	print("¡Compuerta completada! Tipo de recompensa: ", tipo_recompensa)
	
	# Buscamos al jugador en el árbol para aplicarle la mejora
	var jugador = get_tree().root.find_child("Jugador", true, false)
	if jugador:
		if tipo_recompensa == "Nueva Arma":
			if jugador.has_method("subir_nivel_arma"):
				jugador.subir_nivel_arma()
		elif tipo_recompensa == "Reclutar Aliado":
			if jugador.has_method("sumar_aliado"):
				jugador.sumar_aliado()
				
	# Eliminamos la compuerta del mapa de forma limpia
	get_parent().queue_free()