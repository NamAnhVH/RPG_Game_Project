extends "res://Characters/BattleCharacters/AI.gd"
class_name Enemy

func _ready():
	set_state()

func set_state():
	state.add_state(States.IDLE)
	state.add_state(States.CHASE)
	state.add_state(States.ATTACKING)
	state.add_state(States.PRE_ATTACK)
	state.add_state(States.DIE)
	state.set_state(States.IDLE)

func _on_Enemy_enter_idle_state():
	state.set_state(States.IDLE)
