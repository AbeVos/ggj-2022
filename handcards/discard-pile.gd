extends Control
signal action_ended(turn, result)
signal hand_discarded

export(NodePath) var cards_path

var tween


func _ready():
    tween = Tween.new()
    add_child(tween)


func _on_Root_next_action(turn: String, player: int):
    if turn != "discard":
        return

    if player != 0:
        emit_signal("action_ended", turn, {"skipped": true})
        return

    visible = true

    discard_hand()

    yield(self, "hand_discarded")

    visible = false
    emit_signal("action_ended", turn, {})


func discard_hand():
    var cards = get_node(cards_path)

    for follower in cards.get_children():
        var card = follower.get_node("HandCard")

        var position = card.global_position
        var rotation = card.global_rotation_degrees

        follower.remove_child(card)
        cards.remove_child(follower)
        follower.queue_free()

        add_child(card)
        card.global_position = position
        card.global_rotation_degrees = rotation

        tween.interpolate_property(
            card, "global_position",
            position, rect_position, 1.0,
            Tween.TRANS_BACK, Tween.EASE_IN_OUT)
        tween.interpolate_property(
            card, "global_rotation_degrees",
            rotation, 0, 1.0,
            Tween.TRANS_BACK, Tween.EASE_IN_OUT)
        tween.start()

        yield(get_tree().create_timer(0.5), "timeout")

    yield(tween, "tween_all_completed")
    emit_signal("hand_discarded")
