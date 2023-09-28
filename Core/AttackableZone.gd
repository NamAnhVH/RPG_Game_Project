extends Area2D

signal enter_attacking_state()
signal enter_chase_state()
signal ready_enter_chase_state()

onready var parent = get_parent()

func _on_AttackableZone_body_entered(character):
	if character is PlayableCharacter && parent.state.get_state() == States.CHASE:
		emit_signal("enter_attacking_state")

func _on_AttackableZone_body_exited(character):
	if character is PlayableCharacter:
		if parent.state.get_state() == States.ATTACKING:
			emit_signal("enter_chase_state")
		elif parent.state.get_state() == States.PRE_ATTACK:
			emit_signal("ready_enter_chase_state")
