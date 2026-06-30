extends Node3D

@onready var pieza_original = $PiezaCamino
@onready var jugador = $Jugador

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
	
	# Desplazamos el punto de control para la siguiente pieza
	proxima_posicion_z -= largo_pieza
	piezas_creadas += 1

func crear_meta():
	print("¡La meta está cerca!");
	
# Puedes pegar esto al final del script del Jugador
func _input(event):
	# Si presionas la tecla "R", el juego se reinicia desde cero limpiamente
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
