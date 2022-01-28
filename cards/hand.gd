extends Node2D

export(int) var cards_in_hand = 3


func _ready():
    # TODO: Draw random cards.
    var cards = draw_cards(cards_in_hand)

    for idx in range(cards_in_hand):
        add_child(cards[idx])
        # TODO: Display card.
