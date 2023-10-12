extends Node2D

onready var inventory_slots = $Inventory/InventorySlots
onready var parent = get_parent()
onready var equip_slots = $Equipment.get_children()

var mouse_exited = false

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "open_information_item", [slots[i]])
		slots[i].connect("mouse_exited", self, "close_information_item", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = Slot.SlotType.INVENTORY
		
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].connect("mouse_entered", self, "open_information_item", [equip_slots[i]])
		equip_slots[i].connect("mouse_exited", self, "close_information_item", [equip_slots[i]])
		equip_slots[i].slot_index = i
	set_equip_slots()
	
	initialize_inventory()
	initialize_equips()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		var index = str(i)
		if PlayerInventory.inventory.has(index):
			slots[i].initialize_item(PlayerInventory.inventory[index][0], PlayerInventory.inventory[index][1], PlayerInventory.inventory[index][2])

func initialize_equips():
	for i in range(equip_slots.size()):
		var index = str(i)
		if PlayerInventory.equips.has(index):
			equip_slots[i].initialize_item(PlayerInventory.equips[index][0], PlayerInventory.equips[index][1])

func slot_gui_input(event, slot: Slot):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_LEFT:
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
			elif event.button_index == BUTTON_RIGHT:
				if !parent.holding_item and slot.item:
					drop_slot_item(slot)

func open_information_item(slot: Slot):
	if slot.item:
		parent.information.set_information_item(slot.item)
		parent.information.visible = true

func close_information_item(_slot: Slot):
	if parent.information.visible:
		parent.information.visible = false

func _input(event):
	var mouse = get_global_mouse_position()
	if parent.holding_item:
		parent.holding_item.global_position = mouse
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == BUTTON_RIGHT:
					drop_holding_item()

func able_to_put_into_slot(slot: Slot):
	var holding_item = parent.holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name][Items.ITEM_CATEGORY]
	if holding_item_category == Items.CLOTH:
		holding_item_category = JsonData.item_data[holding_item.item_name][Items.CLOTH_CATEGORY]
		
	if slot.slot_type == Slot.SlotType.WEAPON:
		return holding_item_category == Items.WEAPON
	elif slot.slot_type == Slot.SlotType.HAT:
		return holding_item_category == Items.HAT
	elif slot.slot_type == Slot.SlotType.SHIRT:
		return holding_item_category == Items.SHIRT
	elif slot.slot_type == Slot.SlotType.PANTS:
		return holding_item_category == Items.PANTS
	elif slot.slot_type == Slot.SlotType.SHOES:
		return holding_item_category == Items.SHOES
	elif slot.slot_type == Slot.SlotType.ACCESSORY:
		return holding_item_category == Items.ACCESSORY
	
	return true

func left_click_empty_item(slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(parent.holding_item, slot)
		slot.put_into_slot(parent.holding_item)
		parent.holding_item = null

func left_click_different_item(event: InputEvent, slot: Slot):
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
		var stack_size = int(JsonData.item_data[slot.item.item_name][Items.STACK_SIZE])
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

func left_click_not_holding(slot: Slot):
	PlayerInventory.remove_item(slot)
	parent.holding_item = slot.item
	slot.pick_from_slot()
	parent.holding_item.global_position = get_global_mouse_position()

# Sua lai item (item_drop => item)
func drop_holding_item():
	Globals.drop_item(parent.holding_item, Globals.player)
	parent.holding_item.queue_free()
	parent.holding_item = null

func drop_slot_item(slot: Slot):
	PlayerInventory.remove_item(slot)
	Globals.drop_item(slot.item, Globals.player)
	slot.drop_from_slot()

func set_equip_slots():
	equip_slots[0].slot_type = Slot.SlotType.HAT
	equip_slots[1].slot_type = Slot.SlotType.ACCESSORY
	equip_slots[2].slot_type = Slot.SlotType.SHIRT
	equip_slots[3].slot_type = Slot.SlotType.WEAPON
	equip_slots[4].slot_type = Slot.SlotType.ACCESSORY
	equip_slots[5].slot_type = Slot.SlotType.PANTS
	equip_slots[6].slot_type = Slot.SlotType.ACCESSORY
	equip_slots[7].slot_type = Slot.SlotType.ACCESSORY
	equip_slots[8].slot_type = Slot.SlotType.SHOES
	equip_slots[9].slot_type = Slot.SlotType.ACCESSORY
