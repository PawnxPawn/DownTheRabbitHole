class_name ComponentsUtil

enum Field {
	NAME,
	PATH,
}

enum ComponentType {
	NONE,
	GRAVITY,
	INPUT_SOURCE,
	MOVE,
	PLAYER_INPUT,
}

const COMPONENT_DATA = {
	ComponentType.NONE: { 
		Field.NAME: &"",
		Field.PATH: &"",
	},
	ComponentType.GRAVITY: {
		Field.NAME: &"GravityComponent",
		Field.PATH: &"uid://ckkpqo3bx8v2t",
	},
	ComponentType.INPUT_SOURCE: {
		Field.NAME: &"InputSource",
		Field.PATH: &"uid://dl43npbh2cwi1",
	},
	ComponentType.MOVE: {
		Field.NAME: &"MoveComponent",
		Field.PATH: &"uid://bbes4yv7s8fo6",
	},
	ComponentType.PLAYER_INPUT: {
		Field.NAME: &"PlayerInput",
		Field.PATH: &"uid://l0vqpkec40fk",
	},
}


static func get_component_type(value: StringName) -> ComponentType:
	for key in COMPONENT_DATA:
		if COMPONENT_DATA[key][Field.NAME] == value:
			return key
	return ComponentType.NONE


static func get_name(type: ComponentType) -> StringName:
	return COMPONENT_DATA[type][Field.NAME]


static func get_path(type: ComponentType) -> String:
	return COMPONENT_DATA[type][Field.PATH]


static func is_valid(type: ComponentType) -> bool:
	return type != ComponentType.NONE and COMPONENT_DATA.has(type)


static func create(type:ComponentType, p_owner: Node) -> Component:
	var path = get_path(type)
	var component = load(path)
	if not is_instance_valid(component):
		push_error("ComponentsUtil: Failed to create component: %s" % ComponentType.keys()[type])
		return null
	return component.new(p_owner)
