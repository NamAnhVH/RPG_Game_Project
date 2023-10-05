extends Node2D

const SLOT = preload("res://Inventory/Slot.gd")

onready var inventory_slots = $Inventory/InventorySlots
onready var parent = get_parent()
onready var equip_slots = $Equipment.get_children()

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SLOT.SlotType.INVENTORY
		
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slot_type = SLOT.SlotType.HAT
	equip_slots[1].slot_type = SLOT.SlotType.ACCESSORY
	equip_slots[2].slot_type = SLOT.SlotType.SHIRT
	equip_slots[3].slot_type = SLOT.SlotType.ACCESSORY
	equip_slots[4].slot_type = SLOT.SlotType.ACCESSORY
	equip_slots[5].slot_type = SLOT.SlotType.PANTS
	equip_slots[6].slot_type = SLOT.SlotType.ACCESSORY
	equip_slots[7].slot_type = SLOT.SlotType.ACCESSORY
	equip_slots[8].slot_type = SLOT.SlotType.SHOES
	equip_slots[9].slot_type = SLOT.SlotType.ACCESSORY
	
	initialize_inventory()
	initialize_equips()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])

func slot_gui_input(event, slot: SLOT):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if parent.holding_item != null:
				if !slot.item:
					left_click_empty_item(slot)
				else:
					if parent.holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)

func _input(event):
	if parent.holding_item:
		parent.holding_item.global_position = get_global_mouse_position()

func able_to_put_into_slot(slot: SLOT):
	var holding_item = parent.holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	if holding_item_category == "Clothes":
		holding_item_category = JsonData.item_data[holding_item.item_name]["ClothCategory"]
	
	if slot.slot_type == SLOT.SlotType.HAT:
		return holding_item_category == "Hat"
	elif slot.slot_type == SLOT.SlotType.SHIRT:
		return holding_item_category == "Shirt"
	elif slot.slot_type == SLOT.SlotType.PANTS:
		return holding_item_category == "Pants"
	elif slot.slot_type == SLOT.SlotType.SHOES:
		return holding_item_category == "Shoes"
	elif slot.slot_type == SLOT.SlotType.ACCESSORY:
		return holding_item_category == "Accessory"
	
	return true

func left_click_empty_item(slot: SLOT):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(parent.holding_item, slot)
		slot.put_into_slot(parent.holding_item)
		parent.holding_item = null

func left_click_different_item(event: InputEvent, slot: SLOT):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(parent.holding_item, slot)
		var temp_item = slot.item
		slot.pick_from_slot()
		temp_item.global_position = event.global_position
		slot.put_into_slot(parent.holding_item)
		parent.holding_item = temp_item

func left_click_same_item(slot):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= parent.holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, parent.holding_item.item_quantity)
			slot.item.add_item_quantity(parent.holding_item.item_quantity)
			parent.holding_item.queue_free()
			parent.holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			parent.holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SLOT):
	PlayerInventory.remove_item(slot)
	parent.holding_item = slot.item
	slot.pick_from_slot()
	parent.holding_item.global_position = get_global_mouse_position()
