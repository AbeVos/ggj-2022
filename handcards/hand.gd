extends Control

signal action_ended(turn, result)
signal cards_drawn
signal card_added
signal cards_reshuffled

var card_scene = preload("res://handcards/HandCard.tscn")

var card_db = preload("res://data/cards.tres")
var deck_db = preload("res://data/deck.tres")

var deck := []

export(int) var cards_in_hand = 3
export(NodePath) var board
export(NodePath) var discard_pile

var card_tween

func _ready():
    card_tween = Tween.new()
    add_child(card_tween)

    for card_id in deck_db.deck_data:
        deck.push_front(card_id)

    randomize()
    deck.shuffle()


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
        if card == null:
            push_error("Follower " + follow.name + " has no child!")

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
    card_tween.remove_all()

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
    # yield(card_tween, "tween_all_completed")


func draw_card():
    var card = card_scene.instance()
    card.hand = self

    #Assign a random resource.
    if len(deck) < 3:
        reshuffle_deck()

    var id = deck.pop_back()
    card.get_child(1).id = id

    return card


func reshuffle_deck():
    var pile = get_parent().get_child(2)
    print(pile)

    if len(pile.discarded_card_ids) > 1:
        for id in pile.discarded_card_ids:
            deck.push_back(id)

        deck.shuffle()
        emit_signal("cards_reshuffled")


func _on_Root_next_action(turn, player):
    var can_place = get_node(board).player_can_place()

    match turn:
        "draw":
            # If it isn't the player's turn or if the player cannot
            # place a card (there is no space), this step is skipped.
            if player != 0 or not can_place:
                emit_signal("action_ended", "draw", {"skipped": true})
            else:
                draw_hand()
                yield(self, "cards_drawn")
                emit_signal("action_ended", "draw", {})
        "place":
            if can_place:
                for follower in $Cards.get_children():
                    var card = follower.get_node("HandCard")
                    card.activate()
            else:
                emit_signal("action_ended", "place", {"skipped": true})
        "discard":
            if player == 0 and not can_place:
                emit_signal("action_ended", "discard", {"skipped": true})
        _:
            for follower in $Cards.get_children():
                var card = follower.get_node("HandCard")
                card.deactivate()
