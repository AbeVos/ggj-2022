extends Node2D

signal action_ended(turn, result)
signal new_angle(angle)
signal rotation_complete

export(int) var sectors = 6  # Number of card slots on each side.
export(float, 0, 5) var rotation_duration = 1.0

var tween
var angle = 0


func _ready():
    tween = Tween.new()
    add_child(tween)


func rotate_board(turns: int):
    var clockwise = turns > 0
    for _idx in range(abs(turns)):
        single_rotation(clockwise)
        yield(tween, "tween_all_completed")

        angle = angle % (2 * sectors)
        emit_signal("new_angle", angle)

    emit_signal("rotation_complete")


func single_rotation(clockwise: bool):
    var angle_degrees = 360 / (2.0 * sectors)

    if not clockwise:
        angle_degrees = -angle_degrees

    tween.interpolate_property(
        self, "rotation_degrees",
        rotation_degrees, rotation_degrees + angle_degrees, rotation_duration,
        Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
    tween.start()


func _on_Root_next_action(turn, _player):
    if turn == "rotate":
        rotate_board(1)

        yield(self, "rotation_complete")

        emit_signal("action_ended", turn, {})
