extends Node3D
class_name AutoShooter

@export_category("Configuración de Disparo")
@export var escena_bala: PackedScene
@export var velocidad_disparo: float = 0.4 # Cadencia en segundos entre tiros
@export var daño_por_bala: int = 1

var tiempo_desde_ultimo_disparo: float = 0.0

func _process(delta: float) -> void:
	tiempo_desde_ultimo_disparo += delta
	
	# Disparar automáticamente respetando el tiempo de recarga
	if tiempo_desde_ultimo_disparo >= velocidad_disparo:
		disparar_lineal()
		tiempo_desde_ultimo_disparo = 0.0

func disparar_lineal() -> void:
	if not escena_bala: return
	
	var nueva_bala = escena_bala.instantiate()
	get_tree().root.add_child(nueva_bala)
	
	# La bala nace exactamente en la punta del arma del jugador
	nueva_bala.global_position = global_position
	
	if "daño" in nueva_bala:
		nueva_bala.daño = daño_por_bala
		
	# Reseteamos su rotación para asegurarnos de que mire hacia el frente del mundo 3D
	nueva_bala.global_rotation = Vector3.ZERO
