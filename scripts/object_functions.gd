extends Node

@onready var inventory = $"../Inventory"

func get_opened(opener):
	for item in inventory:
		opener.inventory.add_item(item)
