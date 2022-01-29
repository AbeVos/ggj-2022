extends Node2D

var card_scene = preload("res://cards/HandCard.tscn")

export(int) var cards_in_hand = 3

var card_tween


func _ready():
	card_tween = Tween.new()
	add_child(card_tween)

	draw_hand()


func draw_hand():
	# Draw random cards.
	for idx in range(cards_in_hand):
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
	print("Done")


func draw_card():
	var card = card_scene.instance()

	# TODO: Assign a random resource.

	return card
