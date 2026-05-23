class_name Pickup extends Area2D

enum ItemTypes {
	CAKE,
	DRINK,
	COOKIE
}

@export var item_type: ItemTypes

func pickup_item() -> StringName:
	#TODO: ADD Sound Here
	call_deferred(&"queue_free")
	return ItemTypes.keys()[item_type]
