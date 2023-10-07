extends CanvasLayer

onready var inventory = $Inventory
onready var inventory_texture = $Inventory/Inventory
onready var information = $Information

var holding_item = null

func _ready():
	inventory.visible = false
	information.visible = false

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.visible = !inventory.visible
		inventory.initialize_inventory()
		if information.visible:
			information.visible = false
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	if event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
