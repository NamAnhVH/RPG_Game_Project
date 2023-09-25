extends "res://Characters/BattleCharacters/AI.gd"
class_name Enemy

signal enter_idle_state()
signal ready_enter_detect_state()

func _ready():
	set_state()

func set_state():
	state.add_state(Constants.IDLE)
	state.add_state(Constants.DETECTING)
	state.add_state(Constants.ATTACKING)
	state.add_state(Constants.PRE_ATTACK)
	state.add_state(Constants.DIE)
	state.set_state(Constants.IDLE)

func _on_ActiveArea_body_entered(intruder):
	if intruder is PlayableCharacter && state.get_state() == Constants.IDLE:
		state.set_state(Constants.DETECTING)

func _on_ActiveArea_body_exited(intruder):
	if intruder is PlayableCharacter && state.get_state() == Constants.DETECTING:
		state.set_state(Constants.IDLE)
		emit_signal("enter_idle_state")

func _on_AttackArea_body_entered(intruder):
	if intruder is PlayableCharacter && state.get_state() == Constants.DETECTING:
		state.set_state(Constants.ATTACKING)

func _on_AttackArea_body_exited(intruder):
	if intruder is PlayableCharacter:
		if state.get_state() == Constants.ATTACKING:
			state.set_state(Constants.DETECTING)
		elif state.get_state() == Constants.PRE_ATTACK:
			emit_signal("ready_enter_detect_state")
