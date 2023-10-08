extends Enemy

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
		if global_position.distance_to(random_position) > 50:
			move_along_path()
		else:
			stop_moving()

func attacking_state():
	if !attack_cooldown.is_stopped():
		if attack_time.is_stopped():
			move_around_target(target.global_position)
	else:
		state.set_state(States.PRE_ATTACK)

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

func animation_setup():
	if velocity != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Move/blend_position", velocity)
		animation_state.travel("Move")
	else:
		animation_state.travel("Idle")

#Thêm ti le roi item cho slime
func drop_item():
	var item = preload("res://Item/Item.gd").new()
	match randi() % 3: #DROP ITEM RATE
		0:
			item.set_item("Stone Sword", {Items.CRIT_RATE: 2})
		1:
			item.set_item("Iron Sword", {Items.CRIT_DAMAGE: 2})
		2:
			item.set_item("Apple", {}, 5)
	Globals.drop_item(item, self)


#_on_enemy_died()
func _on_Slime_died():
	state.set_state(States.DIE)
	animation_state.travel("Die")
	drop_item()

func die_animation_finished():
	queue_free()

