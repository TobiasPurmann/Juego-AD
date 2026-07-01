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
	# 1. Verificación para enemigos/barriles
	if body.is_in_group("barriles") or body.has_node("BarrelHealth"):
		var vida_nodo = body.get_node("BarrelHealth")
		if vida_nodo:
			vida_nodo.recibir_daño(daño)
		queue_free() # La bala se destruye
		return

	# 2. Verificación para la compuerta de mejora
	if body.is_in_group("mejoras") or body.has_node("ContadorMejora"):
		var mejora_nodo = body.get_node("ContadorMejora")
		if mejora_nodo:
			# Cada bala reduce el contador en 1 (o según el daño)
			mejora_nodo.registrar_impacto(1) 
		queue_free() # La bala se destruye
		return
