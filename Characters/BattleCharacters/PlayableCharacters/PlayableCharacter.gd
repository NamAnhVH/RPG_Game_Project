extends BattleCharacter
class_name PlayableCharacter

const HAND_RADIUS = 20
const BIAS = Vector2(0, 5)

var move_input := Vector2()
var mouse := Vector2()
var stats = PlayerStats

func _unhandled_input(event):
	if event.is_action_pressed("attack") && attack_cooldown.is_stopped():
		state.set_state(States.ATTACK)
		attack()

func _ready():
	stats.connect("no_health", self, "queue_free")
	set_state()

func _physics_process(delta):
	if state.get_state() == States.MOVE:
		move_state()
	if state.get_state() == States.ATTACK:
		attack_state()

func set_state():
	state.add_state(States.MOVE)
	state.add_state(States.ATTACK)
	state.set_state(States.MOVE)

func move_state():
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	move_input = move_input.normalized()
	
	mouse = (get_global_mouse_position() - global_position - BIAS).normalized()
	animation_tree.set("parameters/Attack/blend_position", mouse)

	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
	velocity = lerp(velocity, move_input * move_speed_unit * 24, get_move_weight())
	velocity = move_and_slide(velocity)

func attack_state():
	velocity = Vector2.ZERO
	animation_tree.set("parameters/Idle/blend_position", mouse)
	animation_state.travel("Attack")
	attack_cooldown.start()

func attack():
	var attack_area = preload("res://Attack/Weapon/StoneSword.tscn").instance()
	body.add_child(attack_area)
	var rotation = atan2(mouse.y, mouse.x)
	attack_area.rotation = rotation
	attack_area.position = mouse * HAND_RADIUS - BIAS
	attack_area.set_attacker(self)

func attack_animation_finished():
	state.set_state(States.MOVE)

func _on_PlayableCharacter_lose_health(amount):
	stats.set_health(stats.health - amount)
