extends "res://Characters/BattleCharacters/Enemies/Enemy.gd"

func _physics_process(delta):
	if state.get_state() == "DETECTING":
		var target = get_target()
		if target == null:
			target = get_ideal_target()
		if target != null:
			move_towards(target.global_position)
	else:
		if position.distance_to(random_target) < 1:
			generate_random_target()
		else:
			move_towards(random_target)
		
	_apply_movement()



