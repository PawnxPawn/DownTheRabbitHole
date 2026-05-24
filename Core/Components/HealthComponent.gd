class_name HealthComponent extends Component

signal hp_changed(hp:float)
signal died


var max_health: float = 120.0

var hp: float = max_health:
	set(value):
		var new_hp = value
		print(value)
		if new_hp <= 0.0:
			hp = 0.0
			died.emit()
		elif new_hp > max_health:
			hp = max_health
			hp_changed.emit()
		else:
			hp = value
			hp_changed.emit()
