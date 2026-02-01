class_name FighterData extends Resource

@export var type: FighterClass.Type = FighterClass.Type.Normal
@export var hp: int = 20
@export var strength: int = 10
@export var agility: int = 10
@export var intelligence: int = 10

static func Make(t: FighterClass.Type, hp:int, str:int, agi:int, intl:int) -> FighterData:
	var s := FighterData.new()
	s.type = t
	s.hp = hp
	s.strength = str
	s.agility = agi
	s.intelligence = intl
	return s
