extends BattleCharacter
class_name PlayableCharacter

const HAND_RADIUS = 24
var move_input := Vector2()
var mouse := Vector2()

func _ready():
	set_state()

func _physics_process(delta):
	if state.get_state() == "MOVE":
		move_state()
	if state.get_state() == "ATTACK":
		attack_state()

func set_state():
	state.add_state("MOVE")
	state.add_state("ATTACK")
	state.set_state("MOVE")

func move_state():
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	move_input = move_input.normalized()
	
	mouse = (get_global_mouse_position() - global_position).normalized()
	animation_tree.set("parameters/Idle/blend_position", mouse)
	animation_tree.set("parameters/Run/blend_position", mouse)
	animation_tree.set("parameters/Attack/blend_position", mouse)
	
	if move_input != Vector2.ZERO:
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
	velocity = lerp(velocity, move_input * move_speed_unit * 24, get_move_weight())
	velocity = move_and_slide(velocity)

func _unhandled_input(event):
	if event.is_action_pressed("attack") && attack_cooldown.is_stopped():
		state.set_state("ATTACK")

func attack_state():
	velocity = Vector2.ZERO
	var attack_area = preload("res://Attack/PlayerAttackArea.tscn").instance()
	add_child(attack_area)
	attack_area.position = mouse * HAND_RADIUS
	attack_area.set_attacker(self)
	animation_state.travel("Attack")
	attack_cooldown.start()

func attack_animation_finished():
	state.set_state("MOVE")
