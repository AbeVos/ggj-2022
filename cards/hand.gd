extends Control
signal action_ended(turn, result)
signal cards_drawn

var card_scene = preload("res://cards/HandCard.tscn")

export(int) var cards_in_hand = 3

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

	var followers = $Cards.get_children()
	for idx in range(len(followers)):
		var offset = float(idx) / (len(followers) - 1)
		var follower = followers[idx]

		card_tween.interpolate_property(
			follower, "unit_offset",
			0, offset, 1.0,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

	card_tween.start()

	yield(card_tween, "tween_all_completed")

	emit_signal("cards_drawn")


func draw_card():
	var card = card_scene.instance()

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
		"discard":
			pass
