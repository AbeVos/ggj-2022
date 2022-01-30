extends Node2D
class_name CardSlot

signal slot_occupied(this, card)
signal slot_freed(this, card)
signal slot_clicked(this, card)

var tween
var is_occupied := false
var is_bottom := true


func _ready():
	tween = Tween.new()
	add_child(tween)


func occupy_slot(card):
	if is_occupied:
		push_error(name + " is already occupied!")

	var position = card.global_position
	var rotation = card.global_rotation_degrees

	is_occupied = true
	var card_parent = card.get_parent()
	card_parent.remove_child(card)
	$Slot.add_child(card)

	card.global_position = position
	card.global_rotation_degrees = rotation

	tween.interpolate_property(
		card, "position",
		card.position, Vector2.ZERO, 1.0,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(
		card, "rotation_degrees",
		card.rotation_degrees, 0.0, 1.0,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)

	tween.start()

	yield(tween, "tween_all_completed")

	emit_signal("slot_occupied", self, card)


func free_slot():
	if not is_occupied:
		push_error(name + " is not occupied, cannot be freed!")

	is_occupied = false
	var card = $Slot.get_children()[0]
	$Slot.remove_child(card)

	emit_signal("slot_freed", self, card)

	return card


func _on_Area_input_event(_viewport, event, _shape_idx):
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == 1
	):
		if len($Slot.get_children()) == 1:
			emit_signal("slot_clicked", self, $Slot.get_children()[0])
		elif len($Slot.get_children()) > 1:
			push_error("Slot has more than one child.")
