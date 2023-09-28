extends Area2D

signal enter_chase_state()
signal enter_idle_state()

onready var parent = get_parent()

func _on_PlayerDetectionZone_body_entered(character):
	if character is PlayableCharacter && parent.state.get_state() == States.IDLE:
		emit_signal("enter_chase_state")

func _on_PlayerDetectionZone_body_exited(character):
	if character is PlayableCharacter && parent.state.get_state() == States.CHASE:
		emit_signal("enter_idle_state")
