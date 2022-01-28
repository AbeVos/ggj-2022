extends Node2D

export(int) var radiants = 6
export(float, 0, 5) var rotation_duration = 1.0

var tween


func _ready():
    tween = Tween.new()
    add_child(tween)

    rotate_board(-5)


func rotate_board(turns: int):
    var forward = turns > 0
    for _idx in range(abs(turns)):
        single_rotation(forward)
        yield(tween, "tween_all_completed")


func single_rotation(forward: bool):
    var angle = 360 / (2.0 * radiants)

    if not forward:
        angle = -angle

    tween.interpolate_property(
        self, "rotation_degrees",
        rotation_degrees, rotation_degrees + angle, rotation_duration,
        Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
    tween.start()
