extends Control

#Debug
var r = 350

var card = preload("res://cards/scenes/card.tscn")
var db = preload("res://data/cards.tres")


const AMMOUNT_OF_CARDS = 8
var card_list = []
var card_data
var is_day = [true, true, true, true, false, false, false, false]

func _ready():
    card_data = db.card_data

    #DEBUG zet kaartje in een circel
    for n in range(0,8):
        var card_inst = card.instance()
        var t = ((2 * PI) / 8) * n
        card_inst.position = Vector2(  r * cos(t) , r * sin(t) )
        card_inst.rotation = t + (PI / 2)
        card_inst.scale = Vector2.ONE * 0.7
        card_list.append(card_inst)
        add_child(card_inst)
        print("yee")


    print("YEEEHAWW")
    attack(card_list[2])


func attack(attacking_card):
    var attacker_index = card_list.find(attacking_card)
    var opponent_index = ( attacker_index + AMMOUNT_OF_CARDS / 2 ) % AMMOUNT_OF_CARDS

    var opponent_card = card_list[opponent_index]
    # Handel hier de abillities af

    # verediging - aanval
    var attack_result = 0

    if (is_day[attacker_index]):
        attack_result =  card_data[opponent_card.id].defence_night_value - card_data[attacking_card.id].attack_day_value

    else:
        attack_result = card_data[opponent_card.id].defence_day_value - card_data[attacking_card.id].attack_night_value

    print("Attack result ", attack_result)
