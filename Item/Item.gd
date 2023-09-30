extends Node2D

onready var item = $TextureRect
onready var amount = $Amount

var item_name
var item_quantity

func _ready():
	var rand = randi() % 3
	match rand:
		0:
			item_name = "Iron Sword" 
		1:
			item_name = "Stone Sword"
		2:
			item_name = "Apple"
	
	var item_category = JsonData.item_data[item_name]["ItemCategory"]
	item.texture = load("res://Art/" + item_category + "/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	if stack_size == 1:
		amount.visible = false
	else:
		amount.text = String(item_quantity)

func add_item_quantity(value):
	item_quantity += value
	amount.text = String(item_quantity)

func decrease_item_quantity(value):
	item_quantity -= value
	amount.text = String(item_quantity)
