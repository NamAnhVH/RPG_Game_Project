extends Node

const ITEM_DATA_PATH = "res://Data/ItemData.json"
const PLAYER_INVENTORY_DATA_PATH = "res://Data/PlayerInventoryData.json"
const ITEM_RATE_DROP_DATA_PATH = "res://Data/ItemRateDropData.json"

var item_data: Dictionary
var player_inventory_data: Dictionary
var item_rate_drop_data: Dictionary

func _ready():
	item_data = load_data(ITEM_DATA_PATH)
	player_inventory_data = load_data(PLAYER_INVENTORY_DATA_PATH)
	item_rate_drop_data = load_data(ITEM_RATE_DROP_DATA_PATH)

func load_data(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result

# Fix Save Game

func update_inventory(location, new_data):
	var file = File.new()
	file.open(PLAYER_INVENTORY_DATA_PATH, File.WRITE)
	player_inventory_data[location] = new_data
	file.store_line(JSON.print(player_inventory_data))
	file.close()
