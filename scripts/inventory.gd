extends Node

var inventory = {}

func add_item(item: ItemDatabase.Item, quantity: int = 1):
	if item in inventory:
		inventory[item] += quantity
	else:
		inventory[item] = quantity

func remove_item(item: ItemDatabase.Item, quantity: int = 1):
	if item in inventory:
		inventory[item] -= quantity
		if inventory[item] <= 0:
			inventory.erase(item)
