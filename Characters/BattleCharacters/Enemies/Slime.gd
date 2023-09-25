extends Enemy

var target = null

func _physics_process(delta):
	line_2d.global_position = Vector2.ZERO
	if state.get_state() == Constants.IDLE:
		idle_state()
	if state.get_state() == Constants.DETECTING:
		detecting_state()
	if state.get_state() == Constants.ATTACKING:
		if !attack_cooldown.is_stopped():
			move_around_target(target.global_position, direction)
		else:
			state.set_state(Constants.PRE_ATTACK)
	if state.get_state() == Constants.PRE_ATTACK:
		pre_attack_state()
	if state.get_state() == Constants.DIE:
		stop_moving()
	if state.get_state() != Constants.PRE_ATTACK && state.get_state() != Constants.DIE:
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
		move_along_path()

func idle_state():
	if idle == 0:
		if global_position.distance_to(random_position) < 5:
			generate_random_target()
		else:
			move_along_path()
	else:
		stop_moving()

func pre_attack_state():
	if velocity != Vector2.ZERO:
		animation_tree.set("parameters/Preattack/blend_position", velocity)
		animation_state.travel("Preattack")
		stop_moving()

func pre_attack_animation_finished():
	attack()
	if _on_Slime_ready_enter_detect_state():
		state.set_state(Constants.DETECTING)
	else:
		state.set_state(Constants.ATTACKING)

func attack():
	move_towards(target.global_position, 150.0)
	attack_cooldown.start()

func _on_Slime_enter_idle_state():
	target = null

func _on_Slime_died():
	state.set_state(Constants.DIE)
	animation_state.travel("Die")

func die_animation_finished():
	queue_free()

func _on_Slime_ready_enter_detect_state():
	return
