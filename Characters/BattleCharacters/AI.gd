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

func move_towards(to, move_speed_unit = 3.0):
	var displacement = to - global_position
	var normal = displacement.normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())

func move_around_target(target, direction):
	var displacement = target - global_position
	var normal = Vector2()
	if direction == 0:
		normal = Vector2(displacement.y, -displacement.x).normalized()
	else:
		normal = Vector2(-displacement.y, displacement.x).normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())


func _apply_movement(delta):
	 move_and_slide(velocity)

func generate_random_target():
	var angle = rand_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	random_target = first_position + offset

func stop_moving():
	velocity = Vector2(0, 0)
