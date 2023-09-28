extends Enemy

onready var attack_time = $Timers/AttackTime

var target = null

func _physics_process(delta):
	line_2d.global_position = Vector2.ZERO
	if state.get_state() == States.IDLE:
		idle_state()
	if state.get_state() == States.CHASE:
		chase_state()
	if state.get_state() == States.ATTACKING:
		if !attack_cooldown.is_stopped():
			if attack_time.is_stopped():
				move_around_target(target.global_position, direction)
		else:
			state.set_state(States.PRE_ATTACK)
	if state.get_state() == States.PRE_ATTACK:
		pre_attack_state()
	if state.get_state() == States.DIE:
		stop_moving()
	if state.get_state() != States.PRE_ATTACK && state.get_state() != States.DIE:
		if velocity != Vector2.ZERO:
			animation_tree.set("parameters/Idle/blend_position", velocity)
			animation_tree.set("parameters/Move/blend_position", velocity)
			animation_state.travel("Move")
		else:
			animation_state.travel("Idle")
	_apply_movement(delta)

func chase_state():
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
	if _on_AttackableZone_ready_enter_chase_state():
		state.set_state(States.CHASE)
	else:
		state.set_state(States.ATTACKING)

func attack():
	move_towards(target.global_position, 50.0)
	attack_time.start()
	attack_cooldown.start()

func _on_Slime_died():
	state.set_state(States.DIE)
	animation_state.travel("Die")

func die_animation_finished():
	queue_free()

