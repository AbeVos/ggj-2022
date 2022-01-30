extends Node2D

export(String) var id = "5d836407"

var db = preload("res://data/cards.tres")

var card_name: String = "" setget set_card_name
var attack_day = 0 setget set_attack_day
var attack_night = 0 setget set_attack_night
var defence_day = 0 setget set_defence_day
var defence_night = 0 setget set_defence_night

func _ready():
	var data = db.card_data[id]

	set_attack_day(data.attack_day_value)
	set_attack_night(data.attack_night_value)
	set_defence_day(data.defence_day_value)
	set_defence_night(data.defence_night_value)

	$Image.texture = load(data.image_path)


func set_card_name(value):
	card_name = value


func set_attack_day(value):
	attack_day = value
	$AttackDayLabel.text = str(attack_day)


func set_attack_night(value):
	attack_night = value
	$AttackNightLabel.text = str(attack_night)


func set_defence_day(value):
	defence_day = value
	$DefenceDayLabel.text = str(defence_day)


func set_defence_night(value):
	defence_night = value
	$DefenceNightLabel.text = str(defence_night)
