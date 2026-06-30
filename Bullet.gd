extends Area3D
class_name Bullet

@export var velocidad_propia_bala: float = 30.0
var daño: int = 5 # <--- ¡Aquí configuras cuánto daño hace cada impacto!
var tiempo_maximo_vida: float = 3.0
var jugador: Node3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	jugador = get_tree().root.find_child("Jugador", true, false)
	
	var timer = get_tree().create_timer(tiempo_maximo_vida)
	timer.timeout.connect(func(): queue_free())

func _physics_process(delta: float) -> void:
	var velocidad_jugador: float = 0.0
	if is_instance_valid(jugador) and "velocidad_adelante" in jugador:
		velocidad_jugador = jugador.velocidad_adelante
		
	var velocidad_total = velocidad_jugador + velocidad_propia_bala
	translate_object_local(Vector3.FORWARD * velocidad_total * delta)

# ESTA ES LA FUNCIÓN CLAVE MODIFICADA:
func _on_body_entered(body: Node3D) -> void:
	# Si lo que tocamos pertenece al grupo 'barriles' o tiene el componente de vida
	if body.is_in_group("barriles") or body.has_node("BarrelHealth"):
		var vida_nodo = body.get_node("BarrelHealth")
		if vida_nodo:
			vida_nodo.recibir_daño(daño) # Le aplicamos el daño de la bala
		
		queue_free() # La bala se destruye tras impactar
