extends Node2D
class_name Item

onready var item = $TextureRect
onready var amount = $Amount

var item_name
var item_quantity
var item_category
var item_description
var item_stat

var icon

func _ready():
	item.texture = icon

func add_item_quantity(value):
	item_quantity += value
	amount.text = String(item_quantity)

func decrease_item_quantity(value):
	item_quantity -= value
	amount.text = String(item_quantity)

func set_item(name, stat, quantity = 1):
	item_name = name
	item_category = JsonData.item_data[item_name][Items.ITEM_CATEGORY]
	
	item_quantity = quantity
	if item:
		item.texture = load("res://Art/" + item_category + "/" + item_name + ".png")
	icon = load("res://Art/" + item_category + "/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name][Items.STACK_SIZE])
	if amount != null:
		if stack_size == 1:
			amount.visible = false
		else:
			amount.visible = true
			amount.text = String(item_quantity)
	
	item_description = JsonData.item_data[item_name][Items.DESCRIPTION]
	if JsonData.item_data[item_name].has(Items.BASIC_STAT):
		item_stat = JsonData.item_data[item_name][Items.BASIC_STAT]
	item_stat.merge(stat)


