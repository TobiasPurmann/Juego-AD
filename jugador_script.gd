extends CharacterBody3D
class_name PlayerController

@export_category("Movimiento")
@export var velocidad_adelante: float = 8.0
@export var limite_pista: float = 4.2 # Frenado antes del borde del puente

func _physics_process(_delta: float) -> void:
	# Movimiento constante hacia adelante en el eje Z negativo
	velocity.z = -velocidad_adelante
	
	# Controles laterales simples con flechas o A/D
	var direccion_x = Input.get_axis("ui_left", "ui_right")
	velocity.x = direccion_x * 12.0
	
	move_and_slide()
	
	# Limitar la posición del jugador para que no se caiga del puente
	position.x = clamp(position.x, -limite_pista, limite_pista)

# ESTA ES LA FUNCIÓN CONECTADA QUE DETECTA EL GAME OVER:
func _on_detector_choque_body_entered(body: Node3D) -> void:
	# Este mensaje aparecerá abajo en la consola de Godot cada vez que toques ALGO
	print("El detector tocó el objeto: ", body.name)
	
	if body.is_in_group("barriles"):
		terminar_y_reiniciar_juego()

func terminar_y_reiniciar_juego() -> void:
	# Aquí puedes añadir efectos antes de reiniciar en el futuro (como pausar el juego)
	print("¡GAME OVER! Chocaste contra un barril.")
	
	# REGLA DE ORO DE GODOT PARA REINICIAR:
	# Recargamos la escena actual desde cero, limpiando toda la memoria y spawners
	get_tree().reload_current_scene()

# Variable para llevar el control del nivel actual del jugador
var nivel_arma: int = 1

func subir_nivel_arma() -> void:
	nivel_arma += 1
	print("¡Mejora obtenida! Nivel de arma: ", nivel_arma)
	
	# Buscamos el nodo AutoShooter que está dentro del Jugador
	var shooter = find_child("AutoShooter*", true, false) 
	if shooter:
		# Lógica simple: le restamos tiempo a la cadencia de disparo
		# Usamos max() para ponerle un tope y que la velocidad nunca baje de 0.1 segundos
		shooter.velocidad_disparo = max(0.1, shooter.velocidad_disparo - 0.05)