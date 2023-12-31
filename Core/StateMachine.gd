extends Node
class_name StateMachine

var state = null setget set_state, get_state
var previous_state = null
var states = {}

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta, state)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

func _state_logic(_delta, _current_state): #Trien khai logic cho trang thai hien tai
	pass

func _get_transition(_delta): #Ham xac dinh trang thai moi
	return null

func _enter_state(_new_state, _old_state): #Ham xu ly cac logic khi chuan bi chuyen sang trang thai moi
	pass

func _exit_state(_old_state, _new_state): #Ham xu ly cac logic khi ra khoi trang thai hien tai
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
		if new_state != null:
			_enter_state(new_state, previous_state)

func get_state():
	return state

func add_state(state_name):
	states[state_name] = states.size()
