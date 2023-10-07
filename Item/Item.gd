extends Node2D

const CONSUMABLE = "Consumable"
const WEAPON = "Weapon"

onready var item = $TextureRect
onready var amount = $Amount

var item_name
var item_quantity
var item_category
var item_description
var item_stat

var item_atk
var item_crit_rate
var item_crit_damage

var item_def

var item_add_health
var item_add_energy

func add_item_quantity(value):
	item_quantity += value
	amount.text = String(item_quantity)

func decrease_item_quantity(value):
	item_quantity -= value
	amount.text = String(item_quantity)

func set_item(name, stat, quantity):
	item_name = name
	item_category = JsonData.item_data[item_name]["ItemCategory"]
	
	item_quantity = quantity
	item.texture = load("res://Art/" + item_category + "/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		amount.visible = false
	else:
		amount.visible = true
		amount.text = String(item_quantity)
	
	item_description = JsonData.item_data[item_name]["Description"]
	
	match item_category:
		CONSUMABLE:
			set_item_consumable_stat()
		_:
			item_stat = stat
			match item_category:
				WEAPON:
					set_item_weapon_stat()

func set_item_consumable_stat():
	item_stat = JsonData.item_data[item_name]["Stat"]
	if item_stat["AddHealth"]:
		item_add_health = item_stat["AddHealth"]
	if item_stat["AddEnergy"]:
		item_add_energy = item_stat["AddEnergy"]

func set_item_weapon_stat():
	if item_stat["ATK"]:
		item_atk = item_stat["ATK"]
	if item_stat["CRIT_RATE"]:
		item_crit_rate = item_stat["CRIT_RATE"]
	if item_stat["CRIT_DAMAGE"]:
		item_crit_damage = item_stat["CRIT_DAMAGE"]
