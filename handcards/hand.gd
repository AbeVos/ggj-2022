extends Control
signal action_ended(turn, result)
signal cards_drawn
signal card_added

var card_scene = preload("res://handcards/HandCard.tscn")

export(int) var cards_in_hand = 3
export(NodePath) var discard_pile

var card_tween


func _ready():
    card_tween = Tween.new()
    add_child(card_tween)


func draw_hand():
    # Draw random cards.
    for _idx in range(cards_in_hand):
        var card = draw_card()

        var follower = PathFollow2D.new()
        follower.add_child(card)
        $Cards.add_child(follower)

    move_cards()
    yield(card_tween, "tween_all_completed")

    emit_signal("cards_drawn")


func add_card(card, start_offset: float):
    # Add the new card.
    var follower = PathFollow2D.new()
    follower.add_child(card)
    card.position = Vector2.ZERO

    $Cards.add_child(follower)
    follower.unit_offset = start_offset

    # TODO: Reorder cards.

    for follow in $Cards.get_children():
        card = follow.get_node("HandCard")
        card.activate()

    move_cards()
    yield(card_tween, "tween_all_completed")

    emit_signal("card_added")


func release_card(card):
    for follower in $Cards.get_children():
        var hand_card = follower.get_node("HandCard")

        if hand_card == card:
            follower.remove_child(hand_card)
            $Cards.remove_child(follower)
            follower.queue_free()

            add_child(hand_card)

        else:
            hand_card.deactivate()

    move_cards()


func move_cards():
    # Move the cards to the correct position.
    var followers = $Cards.get_children()
    for idx in range(len(followers)):
        var offset = 0

        match len(followers):
            1:
                offset = 0.5
            2:
                offset = (idx + 1) / 3.0
            _:
                offset = float(idx) / (len(followers) - 1)

        var follower = followers[idx]

        card_tween.interpolate_property(
            follower, "unit_offset",
            follower.unit_offset, offset, 1.0,
            Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

    card_tween.start()
    yield(card_tween, "tween_all_completed")


func draw_card():
    var card = card_scene.instance()
    card.hand = self

    # TODO: Assign a random resource.

    return card


func _on_Root_next_action(turn, player):
    match turn:
        "draw":
            if player != 0:
                emit_signal("action_ended", turn, {"skipped": true})
                return

            draw_hand()

            yield(self, "cards_drawn")

            emit_signal("action_ended", turn, {})
        "place":
            for follower in $Cards.get_children():
                var card = follower.get_node("HandCard")
                card.activate()
        _:
            for follower in $Cards.get_children():
                var card = follower.get_node("HandCard")
                card.deactivate()
