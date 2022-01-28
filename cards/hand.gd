extends Node2D

var card_scene = preload("res://cards/HandCard.tscn")

export(int) var cards_in_hand = 3


func _ready():
    var curve = $Path.curve

    # Draw random cards.
    for idx in range(cards_in_hand):
        var card = draw_card()
        $Cards.add_child(card)

        # TODO: Display card.
        var progress = (idx + 0.5) / cards_in_hand * curve.get_baked_length()

        var position = curve.interpolate_baked(progress)
        print(position)
        card.position = position


func draw_card():
    var card = card_scene.instance()

    # TODO: Assign a random resource.

    return card
