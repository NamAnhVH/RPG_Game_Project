extends BattleCharacter

export var max_active_area = 50

onready var first_position = global_position
onready var random_target = first_position

func get_ideal_target():
	var potential_targets = []
	var nearest_target = null
	var distance = INF
	for character in Globals.battle_arena.characters.get_children():
		if character.faction == BattleCharacter.Factions.ALLY:
			var this_distance = (character.global_position - global_position).length()
			if this_distance < distance:
				nearest_target = character
				distance = this_distance
	
	return nearest_target

func move_towards(to):
	var displacement = to - global_position
	var normal = displacement.normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())

func _apply_movement():
	velocity = move_and_slide(velocity)

func generate_random_target():
	var angle = rand_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	random_target = first_position + offset
