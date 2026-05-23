class_name PickupComponent extends Area2D

signal item_pickuped(item:StringName)

func _ready() -> void:
	area_entered.connect(_pickup)


func _pickup(area: Area2D) -> void:
	if not area is Pickup: return
	var pickup: Pickup = area as Pickup
	var item = pickup.pickup_item()
	print(item)
	item_pickuped.emit(item)
