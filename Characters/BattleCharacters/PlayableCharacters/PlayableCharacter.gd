extends BattleCharacter
class_name PlayableCharacter

const HAND_RADIUS = 24

var move_input := Vector2()

func _physics_process(delta):
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	move_input = move_input.normalized()
	
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
	velocity = lerp(velocity, move_input * move_speed_unit * 24, get_move_weight())
	velocity = move_and_slide(velocity)

func _unhandled_input(event):
	if event.is_action_pressed("attack") && attack_cooldown.is_stopped():
		attack()

func attack():
	attack_cooldown.start()
	var attack_area = preload("res://Attack/PlayerAttackArea.tscn").instance()
	add_child(attack_area)
	var mouse = (get_global_mouse_position() - global_position).normalized()
	attack_area.position = mouse.normalized() * HAND_RADIUS
	attack_area.set_attacker(self)