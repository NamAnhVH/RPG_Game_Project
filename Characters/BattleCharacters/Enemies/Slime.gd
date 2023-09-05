extends "res://Characters/BattleCharacters/Enemies/Enemy.gd"

var target = null

onready var change_direction_cooldown = $Timers/ChangeDirectionCooldown

var direction = 0

func _physics_process(delta):
	if state.get_state() == "DETECTING":
		target = get_target()
		if target == null:
			target = get_ideal_target()
		if target != null:
			move_towards(target.global_position)
	else:
		if state.get_state() == "ATTACKING":
			if !attack_cooldown.is_stopped():
				if !attack_animator.is_playing():
					move_around_target(target.global_position, direction)
			else:
				attack_animator.play("PreAttack")
				stop_moving()
		else:
			if position.distance_to(random_target) < 3:
				generate_random_target()
			else:
				move_towards(random_target)
	_apply_movement(delta)

func _on_Slime_enter_attack_state():
	if attack_cooldown.is_stopped():
		attack_cooldown.start()

func attack():
	move_towards(target.global_position, 150.0)
	attack_animator.play("RESET")
	attack_cooldown.start()


func _on_ChangeDirectionCooldown_timeout():
	if direction == 0:
		direction = 1
	else:
		direction = 0

func _on_AttackAnimator_animation_finished(anim_name):
	if anim_name == "PreAttack":
		attack()
