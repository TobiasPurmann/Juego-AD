extends Label3D
class_name UIHealthText

# Buscamos el componente de vida que creamos en el paso anterior
@onready var componente_vida: BarrelHealth = $"../BarrelHealth"

func _ready() -> void:
	if componente_vida:
		# Nos suscribimos limpiamente a su señal. Cuando la vida cambie, se ejecutará nuestra función
		componente_vida.vida_cambiada.connect(_actualizar_texto)

func _actualizar_texto(nueva_vida: int) -> void:
	# Convertimos el número de vida a texto para mostrarlo en el Label3D
	text = str(nueva_vida)
