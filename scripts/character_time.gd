extends Node

@onready var time_manager = $"../../../time_manager"

@onready var data = $"../Data"
@onready var functions = $"../Functions"
@onready var AI = $"../AI"

func _ready():
	time_manager.time_passed.connect(time_passed)

func time_passed():
	if data.health < data.max_health:
		if data.time_health_regen < data.health_regen_speed:
			data.time_health_regen += 1
		elif data.time_health_regen >= data.health_regen_speed: #Might just change this to an else statement
			data.time_health_regen -= data.health_regen_speed
			functions.regen_health()
			print("regeneded")
			
	if data.AI == true:
		if data.time_action < 100:
			data.time_action += 1
		elif data.time_action >= 100:
			AI.AI_action()
