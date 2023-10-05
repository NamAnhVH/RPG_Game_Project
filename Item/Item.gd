extends Node2D

onready var item = $TextureRect
onready var amount = $Amount

var item_name
var item_quantity

func add_item_quantity(value):
	item_quantity += value
	amount.text = String(item_quantity)

func decrease_item_quantity(value):
	item_quantity -= value
	amount.text = String(item_quantity)

func set_item(name, quantity):
	item_name = name
	var item_category = JsonData.item_data[item_name]["ItemCategory"]
	
	item_quantity = quantity
	item.texture = load("res://Art/" + item_category + "/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		amount.visible = false
	else:
		amount.visible = true
		amount.text = String(item_quantity)
