extends BattleCharacter

export var max_active_area = 50

signal died()
signal enter_idle_state()

onready var change_direction_cooldown = $Timers/ChangeDirectionCooldown
onready var idle_time = $Timers/IdleTime
onready var line_2d = $Line2D

onready var first_position = global_position
onready var random_position = first_position setget set_random_position, get_random_position
onready var path = PoolVector2Array() setget set_path
export var max_health = 10.0

onready var health = max_health setget set_health

var direction
var idle = 0

func _ready():
	idle_time.start()
	direction = 0

func get_ideal_target():
	var nearest_target = null
	var distance = INF
	for character in Globals.map.characters.get_children():
		if character is KinematicBody2D:
			if character.faction == BattleCharacter.Factions.ALLY:  
				var this_distance = (character.global_position - global_position).length()
				if this_distance < distance:
					nearest_target = character
					distance = this_distance
					distance = this_distance
	if nearest_target != null:
		return nearest_target
	else:
		emit_signal("enter_idle_state")

func move_towards(to: Vector2, move_speed_unit):
	var displacement = to - global_position
	var normal = displacement.normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())

func move_around_target(target: Vector2):
	var displacement = target - global_position
	var normal = Vector2()
	if direction == 0:
		normal = Vector2(displacement.y, -displacement.x).normalized()
	else:
		normal = Vector2(-displacement.y, displacement.x).normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())

func move_along_path():
	if path.size() > 1:
		var normal = (path[1] - global_position).normalized()
		velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())
		if global_position == path[0]:
			path.remove(0)

func stop_moving():
	velocity = Vector2.ZERO

func _apply_movement(_delta):
	  velocity = move_and_slide(velocity)

func generate_random_target():
	var angle = rand_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	set_random_position(first_position + offset)

func _on_ChangeDirectionCooldown_timeout():
	if direction == 0:
		direction = 1
	else:
		direction = 0

func _on_IdleTime_timeout():
	if idle == 0:
		idle = 1
		idle_time.set_wait_time(rand_range(1,3))
		idle_time.start()
	else: 
		idle = 0
		idle_time.set_wait_time(rand_range(4,6))
		idle_time.start()

func _on_PlayerDetectionZone_enter_chase_state():
	state.set_state(States.CHASE)

func _on_PlayerDetectionZone_enter_idle_state():
	state.set_state(States.IDLE)

func _on_AttackableZone_enter_attacking_state():
	state.set_state(States.ATTACKING)

func _on_AttackableZone_enter_chase_state():
	state.set_state(States.CHASE)

func _on_AttackableZone_ready_enter_chase_state():
	return

func _on_AI_lose_health(amount):
	set_health(health - amount)

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("died")

func set_random_position(position):
	random_position = position

func get_random_position():
	return random_position

func set_path(value: PoolVector2Array):
	path = value
	if path != null:
		line_2d.points = path
		if value.size() == 0:
			return


