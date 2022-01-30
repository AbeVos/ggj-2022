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


func _ready():
    tween = Tween.new()
    add_child(tween)

    for sector in range(2 * sectors):
        var slot = slot_scene.instance()

        $Slots.add_child(slot)
        slot.connect("slot_occupied", self, "_on_CardSlot_slot_occupied")

        var angle_offset = 360.0 / (2 * sectors) * (sector + 0.5)
        slot.position = radius * Vector2(
            cos(deg2rad(angle_offset)),
            sin(deg2rad(angle_offset)))
        slot.rotation_degrees = angle_offset + 90


func rotate_board(turns: int):
    var clockwise = turns > 0
    for _idx in range(abs(turns)):
        single_rotation(clockwise)
        yield(tween, "tween_all_completed")

        angle = angle % (2 * sectors)
        emit_signal("new_angle", angle)

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


func _on_Root_next_action(turn, player):
    match turn:
        "rotate":
            rotate_board(1)

            yield(self, "rotation_complete")

            emit_signal("action_ended", turn, {})
        "place":
            if player == 1:
                emit_signal("action_ended", turn, {"skipped": true})


func _on_CardSlot_slot_occupied(slot, card):
    emit_signal("action_ended", "place", {"slot": slot, "card": card})
