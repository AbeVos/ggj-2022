extends Node2D

signal action_ended(turn, result)
signal new_angle(angle)
signal rotation_complete

var slot_scene = preload("res://card-slots/CardSlot.tscn")

export(int) var sectors = 4  # Number of card slots on each side.
export(float) var radius = 150.0
export(float, 0, 5) var rotation_duration = 2.0

var tween
var angle = 0
var player_attacking = false
var card_list = []
var card_data
var is_day = [true, true, true, true, false, false, false, false]


func _ready():
	tween = Tween.new()
	add_child(tween)

	for sector in range(2 * sectors):
		var slot = slot_scene.instance()
		slot.get_node("Label").text = str(sector)

		$Slots.add_child(slot)
		slot.connect("slot_occupied", self, "_on_CardSlot_slot_occupied")
		slot.connect("slot_clicked", self, "_on_CardSlot_slot_clicked")

		var angle_offset = (
			360.0 / (2 * sectors)  # Angle of a sector.
			* (sector + 0.5)  # Sector index offset + halfsector offset.
		)
		slot.position = radius * Vector2(
			cos(deg2rad(angle_offset)),
			sin(deg2rad(angle_offset)))
		slot.rotation_degrees = angle_offset + 90


func rotate_board(turns: int):
	var clockwise = turns > 0
	for _idx in range(abs(turns)):
		single_rotation(clockwise)
		yield(tween, "tween_all_completed")

		angle = (angle + sign(turns)) % (2 * sectors)
		emit_signal("new_angle", angle)
		print("New angle ", angle)

	for idx in range(2 * sectors):
		var is_bottom = slot_is_bottom(idx)
		var slot = $Slots.get_children()[idx]


	emit_signal("rotation_complete")


func single_rotation(clockwise: bool):
	var angle_degrees = 360.0 / (2 * sectors)

	if not clockwise:
		angle_degrees = -angle_degrees

	tween.interpolate_property(
		self, "rotation_degrees",
		rotation_degrees, rotation_degrees + angle_degrees, rotation_duration,
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()


func slot_is_bottom(slot: int) -> bool:
	return (slot + angle) % (2 * sectors) < sectors


func get_card_in_slot(idx: int):
	var slot = $Slots.get_children()[idx].get_node("Slot")

	print(slot.get_children())
	if len(slot.get_children()) == 1:
		return slot.get_children()[0]

	return null



func player_can_attack() -> bool:
	for idx in range(2 * sectors):
		if not slot_is_bottom(idx):
			continue

		if get_card_in_slot(idx) != null:
			return true

	return false


func attack(attacker_index: int):
	# var attacker_index = card_list.find(attacking_card)
	var opponent_index = (
		(attacker_index + sectors)
		% (2 * sectors))

	var attacking_card = get_card_in_slot(attacker_index)
	var opponent_card = get_card_in_slot(opponent_index)

	if attacking_card == null:
		push_error("There is no attacking card")

	if opponent_card == null:
		# TODO: Attack opponent.
		return

	# Handel hier de abillities af

	# verediging - aanval
	var attack_result = 0

	if slot_is_bottom(attacker_index):
		attack_result = (
			card_data[opponent_card.id].defence_night_value
			- card_data[attacking_card.id].attack_day_value
		)

	else:
		attack_result = (
			card_data[opponent_card.id].defence_day_value
			- card_data[attacking_card.id].attack_night_value
		)

	print("Attack result ", attack_result)


func _on_Root_next_action(turn, player):
	player_attacking = false

	match turn:
		"rotate":
			rotate_board(1)

			yield(self, "rotation_complete")

			emit_signal("action_ended", turn, {})
		"place":
			if player > 0:
				emit_signal("action_ended", turn, {"skipped": true})
		"attack":
			if player == 0 and player_can_attack():
				player_attacking = true
			else:
				emit_signal("action_ended", turn, {"skipped": true})


func _on_CardSlot_slot_occupied(slot, card):
	emit_signal("action_ended", "place", {"slot": slot, "card": card})


func _on_CardSlot_slot_clicked(slot, card):
	if not player_attacking:
		return

	print("Attack!")

	var idx = $Slots.get_children().find(slot)

	attack(idx)

	emit_signal("action_ended", "attack", {})
