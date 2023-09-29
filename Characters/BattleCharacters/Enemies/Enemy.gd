extends "res://Characters/BattleCharacters/AI.gd"
class_name Enemy

onready var attack_time = $Timers/AttackTime

var target = null

func _ready():
	set_state()

func _physics_process(delta):
	line_2d.global_position = Vector2.ZERO
	if state.get_state() == States.IDLE:
		idle_state()
	if state.get_state() == States.CHASE:
		chase_state()
	if state.get_state() == States.ATTACKING:
		attacking_state()
	if state.get_state() == States.PRE_ATTACK:
		pre_attack_state()
	if state.get_state() == States.DIE:
		die_state()
	if state.get_state() != States.PRE_ATTACK && state.get_state() != States.DIE:
		animation_setup()
	_apply_movement(delta)

func set_state():
	state.add_state(States.IDLE)
	state.add_state(States.CHASE)
	state.add_state(States.ATTACKING)
	state.add_state(States.PRE_ATTACK)
	state.add_state(States.DIE)
	state.set_state(States.IDLE)

func idle_state():
	pass

func chase_state():
	pass

func attacking_state():
	pass

func pre_attack_state():
	pass

func die_state():
	stop_moving()

func animation_setup():
	pass

func _on_Enemy_enter_idle_state():
	state.set_state(States.IDLE)
