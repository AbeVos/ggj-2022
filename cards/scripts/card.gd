extends Node2D

export var id = "9a416930"
var db = preload("res://data/cards.tres")

func _ready():
    var data = db.card_data[id]

    $CardBack/Label_up.text = data.name
    $CardBack/Label_down.text = data.name

    $CardBack/Attack_day/Label.text = str(data.attack_day_value)
    $CardBack/Attack_night/Label.text =  str(data.attack_night_value)
    $CardBack/Defence_day/Label.text =  str(data.defence_day_value)
    $CardBack/Defence_night/Label.text =  str(data.defence_night_value)

    $CardBack/Image.texture = load(data.image_path)   
