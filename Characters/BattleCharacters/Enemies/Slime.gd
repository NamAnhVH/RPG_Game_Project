extends "res://Characters/BattleCharacters/Enemies/Enemy.gd"

var target = null

func _physics_process(delta):
	if state.get_state() == "DETECTING":
		target = get_target()
		if target == null:
			target = get_ideal_target()
		if target != null:
			move_towards(target.global_position)
#			wall_detector.set_cast_to(target.global_position - global_position)
#			if wall_detector.is_colliding():
#				if wall_detector.get_collider() is TileMap:
#					print(1)
	else:
		if state.get_state() == "ATTACKING":
			if !attack_cooldown.is_stopped():
				if !attack_animator.is_playing():
					move_around_target(target.global_position, direction)
			else:
				attack_animator.play("PreAttack")
				stop_moving()
		else: #IDLE
			if idle == 0:
				if global_position.distance_to(random_target) < 5:
					generate_random_target()
				else:
					move_towards(random_target)
			else:
				stop_moving()
				if !idle_animator.is_playing():
					idle_animator.play("Idle")
	_apply_movement(delta)

func attack():
	move_towards(target.global_position, 150.0)
	attack_animator.play("RESET")
	attack_cooldown.start()

func _on_AttackAnimator_animation_finished(anim_name):
	if anim_name == "PreAttack":
		attack()

func _on_Slime_enter_idle_state():
	target = null
