extends Node3D
class_name Spawner

@export_category("Escenas Requeridas")
@export var escena_barril: PackedScene

@export_category("Configuración")
@export var distancia_entre_barriles: float = 20.0
@export var vida_base_barriles: int = 30

var proxima_posicion_z: float = -30.0
var carriles: Array[float] = [-3.0, 0.0, 3.0] # Izquierda, Centro, Derecha
var jugador: Node3D

func _ready() -> void:
	# Buscamos al jugador en el mapa de forma automática
	jugador = get_tree().root.find_child("Jugador", true, false)

func _process(_delta: float) -> void:
	if not is_instance_valid(jugador): return
	
	# Si el jugador se acerca al horizonte, generamos otra tanda de barriles
	if jugador.global_position.z < proxima_posicion_z + 80.0:
		generar_obstaculo()

func generar_obstaculo() -> void:
	if not escena_barril: return
	
	# Instanciar el obstáculo
	var nuevo_barril = escena_barril.instantiate() as StaticBody3D
	add_child(nuevo_barril)
	
	# Elegir un carril al azar de los tres disponibles
	var carril_elegido = carriles.pick_random()
	nuevo_barril.global_position = Vector3(carril_elegido, 1.0, proxima_posicion_z)
	
	# Configurar la vida de forma aleatoria basada en la dificultad base
	if nuevo_barril.has_node("BarrelHealth"):
		nuevo_barril.get_node("BarrelHealth").vida_maxima = vida_base_barriles + randi_range(10, 100)
		
	# Mover el indicador hacia adelante para el siguiente grupo de barriles
	proxima_posicion_z -= distancia_entre_barriles
