extends BattleCharacter

export var max_active_area = 50

onready var change_direction_cooldown = $Timers/ChangeDirectionCooldown
onready var idle_time = $Timers/IdleTime

onready var first_position = global_position
onready var random_target = first_position

var direction = 0
var idle = 0

func _ready():
	idle_time.start()

func get_ideal_target():
	var potential_targets = []
	var nearest_target = null
	var distance = INF
	for character in Globals.battle_arena.characters.get_children():
		if character.faction == BattleCharacter.Factions.ALLY:
			var this_distance = (character.global_position - global_position).length()
			if this_distance < distance:
				nearest_target = character
				distance = this_distance
	
	return nearest_target

func move_towards(to, move_speed_unit):
	var displacement = to - global_position
	var normal = displacement.normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())

func move_around_target(target, direction):
	var displacement = target - global_position
	var normal = Vector2()
	if direction == 0:
		normal = Vector2(displacement.y, -displacement.x).normalized()
	else:
		normal = Vector2(-displacement.y, displacement.x).normalized()
	velocity = lerp(velocity, normal * move_speed_unit * 24, get_move_weight())


func _apply_movement(delta):
	  move_and_slide(velocity)

func generate_random_target():
	var angle = rand_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	random_target = first_position + offset

func stop_moving():
	velocity = Vector2.ZERO

func _on_ChangeDirectionCooldown_timeout():
	if direction == 0:
		direction = 1
	else:
		direction = 0

func _on_IdleTime_timeout():
	if idle == 0:
		idle = 1
		idle_time.set_wait_time(2)
		idle_time.start()
	else: 
		idle = 0
		idle_time.set_wait_time(5)
		idle_time.start()

