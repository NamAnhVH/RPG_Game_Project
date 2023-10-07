extends KinematicBody2D
class_name ItemDrop

onready var sprite = $Sprite
onready var drop_time = $DropTime

const SPEED = 225
const ACCELERATION = 1000


var item_name
var item_quantity
var item_stat

var player = null
var being_picked_up = false
var drop = false
var velocity := Vector2()
var icon
	
func _ready():
	sprite.texture = icon

func set_item_drop(name, stat, quantity: int = 1):
	item_name = name
	var item_category = JsonData.item_data[item_name]["ItemCategory"]
	item_quantity = quantity
	
	match item_category:
		"Consumable":
			item_stat = JsonData.item_data[item_name]["Stat"]

		"Weapon":
			set_weapon_item_stat()
#		"Cloth":
#			set_cloth_item_stat()
	icon = load("res://Art/" + item_category + "/" + item_name + ".png")

func _physics_process(delta):
	if drop:
		var angle = rand_range(0, 2 * PI)
		var drop_bias = Vector2(cos(angle), sin(angle)) * 3
		velocity = velocity.move_toward(drop_bias * SPEED, ACCELERATION * delta * 3)
		drop = false
		drop_time.start()
	if being_picked_up:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, item_stat, item_quantity)
			queue_free()
	velocity = move_and_slide(velocity)

func pick_up_item(body):
	player = body
	being_picked_up = true

func drop_item(body):
	global_position = body.global_position
	drop = true

func _on_DropTime_timeout():
	velocity = Vector2.ZERO

func set_weapon_item_stat():
	var stat = {
		"ATK": 0,
		"CRIT_RATE": 0,
		"CRIT_DAMAGE": 0,
	}
	match item_name:
		"Stone Sword":
			stat["ATK"] = 2
			stat["CRIT_RATE"] = 2
		"Iron Sword":
			stat["ATK"] = 3
			stat["CRIT_DAMAGE"] = 4
	item_stat = stat

func set_cloth_item_stat():
	pass

