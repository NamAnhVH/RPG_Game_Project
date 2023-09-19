extends Enemy

var target = null

func _physics_process(delta):
	if state.get_state() == "IDLE":
		idle_state()
	if state.get_state() == "DETECTING":
		detecting_state()
	if state.get_state() == "ATTACKING":
		if !attack_cooldown.is_stopped():
			move_around_target(target.global_position, direction)
		else:
			state.set_state("PRE_ATTACK")
	if state.get_state() == "PRE_ATTACK":
		pre_attack_state()
	if state.get_state() == "DIE":
		stop_moving()
	if state.get_state() != "PRE_ATTACK" && state.get_state() != "DIE":
		if velocity != Vector2.ZERO:
			animation_tree.set("parameters/Idle/blend_position", velocity)
			animation_tree.set("parameters/Move/blend_position", velocity)
			animation_state.travel("Move")
		else:
			animation_state.travel("Idle")
	_apply_movement(delta)

func detecting_state():
	target = get_target()
	if target == null:
		target = get_ideal_target()
	if target != null:
		move_towards(target.global_position, move_speed_unit)
#		wall_detector.set_cast_to(target.global_position - global_position)
#		if wall_detector.is_colliding():
#			if wall_detector.get_collider() is TileMap:
#				print(1)

func idle_state():
	if idle == 0:
		if global_position.distance_to(random_target) < 5:
			generate_random_target()
		else:
			move_towards(random_target, move_speed_unit)
	else:
		stop_moving()

func pre_attack_state():
	if velocity != Vector2.ZERO:
		animation_tree.set("parameters/Preattack/blend_position", velocity)
		animation_state.travel("Preattack")
		stop_moving()

func pre_attack_animation_finished():
	state.set_state("ATTACKING")
	attack()

func attack():
	move_towards(target.global_position, 150.0)
	attack_cooldown.start()

func _on_Slime_enter_idle_state():
	target = null

func _on_Slime_died():
	state.set_state("DIE")
	animation_state.travel("Die")

func die_animation_finished():
	queue_free()
