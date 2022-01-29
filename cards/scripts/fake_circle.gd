var card = preload("res://cards/scenes/card.tscn")
var db = preload("res://data/cards.tres")


const ammount_of_cards = 8
var card_list = []
var card_data
var is_day = [true, true, true, true, false, false, false, false]

func _ready():
    card_data = db.card_data
func attack(attacking_card):
    var attacker_index = card_list.find(attacking_card)
    var opponent_index = ( attacker_index + ammount_of_cards / 2 ) % ammount_of_cards

    var opponent_card = card_list[opponent_index]
    # Handel hier de abillities af

    # verediging - aanval
    var attack_result = 0

    if (is_day[attacker_index]):
        attack_result =  card_data[opponent_card.id].defence_night_value - card_data[attacking_card.id].attack_day_value

    else:
        attack_result = card_data[opponent_card.id].defence_day_value - card_data[attacking_card.id].attack_night_value

    print("Attack result ", attack_result)
