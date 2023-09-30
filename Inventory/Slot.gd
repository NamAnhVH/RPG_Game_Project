extends Panel

const ITEM = preload("res://Item/Item.tscn")
const DEFAULT_TEX = preload("res://Art/Inventory/Item/item_slot_default_background.png")
const EMPTY_TEX = preload("res://Art/Inventory/Item/item_slot_empty_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var item = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = DEFAULT_TEX
	empty_style.texture = EMPTY_TEX
	if randi() % 2 == 0:
		item = ITEM.instance()
		add_child(item)
	refresh_style()

func refresh_style():
	if item == null:
		set("custom_styles/panel", empty_style)
	else:
		set("custom_styles/panel", default_style)

func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item = null
	refresh_style()

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()
