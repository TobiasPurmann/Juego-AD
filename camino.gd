extends Node3D

@onready var pieza_original = $PiezaCamino
@onready var jugador = $Jugador

# --- NUEVAS VARIABLES PARA LOS OBSTÁCULOS ---
@export_category("Generación de Obstáculos")
@export var escena_enemigo: PackedScene
@export var escena_compuerta: PackedScene

var largo_pieza: float = 30.0 # Asegúrate de que coincida con el tamaño Z de tu BoxMesh
var lista_caminos: Array = []
var proxima_posicion_z: float = 0.0
var piezas_creadas: int = 0

@export var limite_para_meta: int = 20 # Cuántas piezas antes de la meta

func _ready() -> void:
	# 1. Acomodamos la primera pieza para que empiece justo debajo del jugador
	# Como el pivote está en el centro, la movemos la mitad de su largo hacia adelante
	pieza_original.position = Vector3(0, 0, -largo_pieza / 2)
	lista_caminos.append(pieza_original)
	
	# La próxima pieza se creará justo donde termina esta
	proxima_posicion_z = -largo_pieza
	
	# 2. Creamos 4 piezas hacia adelante para que el horizonte esté cubierto
	for i in range(4):
		crear_siguiente_pieza()

func _process(delta: float) -> void:
	# Si el jugador ya cruzó la primera pieza de la lista...
	if jugador.position.z < lista_caminos[0].position.z - (largo_pieza / 2):
		
		# Si no llegamos a la meta, creamos una pieza nueva al fondo
		if piezas_creadas < limite_para_meta:
			crear_siguiente_pieza()
		else:
			crear_meta()
		
		# Borramos la pieza que quedó completamente atrás
		var pieza_vieja = lista_caminos.pop_front()
		if pieza_vieja != pieza_original:
			pieza_vieja.queue_free()

func crear_siguiente_pieza():
	var nueva_pieza = pieza_original.duplicate()
	add_child(nueva_pieza)
	
	# Posicionamos la pieza alineando su borde trasero con el borde delantero de la anterior
	nueva_pieza.position = Vector3(0, 0, proxima_posicion_z - (largo_pieza / 2))
	lista_caminos.append(nueva_pieza)
	
	# --- LÓGICA DE BIFURCACIÓN (ENEMIGO VS COMPUERTA) ---
	# Verificamos que hayas asignado las escenas en el editor de Godot
	if escena_enemigo and escena_compuerta:
		var enemigo = escena_enemigo.instantiate()
		var compuerta = escena_compuerta.instantiate()
		
		# Los añadimos como hijos de la NUEVA PIEZA para que se muevan o borren con ella
		nueva_pieza.add_child(enemigo)
		nueva_pieza.add_child(compuerta)
		
		# Decidimos al azar si el enemigo va a la derecha (true) o izquierda (false)
		var enemigo_a_la_derecha: bool = randf() > 0.5
		
		# Posiciones en el eje X para los dos carriles
		var posicion_carril_izquierdo: float = -2.5
		var posicion_carril_derecho: float = 2.5
		
		# Ajustamos la altura (Y) según el centro de tus modelos (0.5 es un ejemplo estándar)
		if enemigo_a_la_derecha:
			enemigo.position = Vector3(posicion_carril_derecho, 0.5, 0)
			compuerta.position = Vector3(posicion_carril_izquierdo, 0.5, 0)
		else:
			enemigo.position = Vector3(posicion_carril_izquierdo, 0.5, 0)
			compuerta.position = Vector3(posicion_carril_derecho, 0.5, 0)
	
	# Desplazamos el punto de control para la siguiente pieza
	proxima_posicion_z -= largo_pieza
	piezas_creadas += 1

func crear_meta():
	print("¡La meta está cerca!")
	
func _input(event):
	# Si presionas la tecla "R", el juego se reinicia desde cero limpiamente
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		
	# Si presionas la tecla "ESC", el juego se cierra por completo
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
