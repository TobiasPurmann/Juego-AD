extends Node3D

@onready var pieza_original = $PiezaCamino
@onready var jugador = $Jugador

# --- VARIABLES PARA LOS OBSTÁCULOS ---
@export_category("Generación de Obstáculos")
@export var escena_enemigo: PackedScene
@export var escena_compuerta: PackedScene

var largo_pieza: float = 30.0 # Tamaño Z del piso
var lista_caminos: Array = []
var proxima_posicion_z: float = 0.0
var piezas_creadas: int = 0

@export var limite_para_meta: int = 20

func _ready() -> void:
	# Acomodamos la primera pieza
	pieza_original.position = Vector3(0, 0, -largo_pieza / 2)
	lista_caminos.append(pieza_original)
	proxima_posicion_z = -largo_pieza
	
	# Creamos las primeras 4 piezas
	for i in range(4):
		crear_siguiente_pieza()

func _process(delta: float) -> void:
	# Seguridad: si la lista está vacía, no hacemos nada
	if lista_caminos.is_empty():
		return
		
	# Si el jugador cruzó la primera pieza...
	if jugador.position.z < lista_caminos[0].position.z - (largo_pieza / 2):
		if piezas_creadas < limite_para_meta:
			crear_siguiente_pieza()
		else:
			crear_meta()
		
		# Borramos la pieza vieja
		var pieza_vieja = lista_caminos.pop_front()
		if pieza_vieja != pieza_original:
			pieza_vieja.queue_free()

func crear_siguiente_pieza():
	var nueva_pieza = pieza_original.duplicate()
	add_child(nueva_pieza)
	
	nueva_pieza.position = Vector3(0, 0, proxima_posicion_z - (largo_pieza / 2))
	lista_caminos.append(nueva_pieza)
	
	# --- LÓGICA DE ENEMIGOS Y COMPUERTAS ---
	if escena_enemigo and escena_compuerta:
		var enemigo = escena_enemigo.instantiate()
		var compuerta = escena_compuerta.instantiate()
		
		nueva_pieza.add_child(enemigo)
		nueva_pieza.add_child(compuerta)
		
		var enemigo_a_la_derecha: bool = randf() > 0.5
		
		var posicion_carril_izquierdo: float = -2.5
		var posicion_carril_derecho: float = 2.5
		
		# Alturas corregidas para que la compuerta flote
		var altura_barril: float = 0.5
		var altura_compuerta: float = 1.8
		
		if enemigo_a_la_derecha:
			enemigo.position = Vector3(posicion_carril_derecho, altura_barril, 0)
			compuerta.position = Vector3(posicion_carril_izquierdo, altura_compuerta, 0)
		else:
			enemigo.position = Vector3(posicion_carril_izquierdo, altura_barril, 0)
			compuerta.position = Vector3(posicion_carril_derecho, altura_compuerta, 0)
	
	proxima_posicion_z -= largo_pieza
	piezas_creadas += 1

func crear_meta():
	print("¡La meta está cerca!")
	
func _input(event):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
