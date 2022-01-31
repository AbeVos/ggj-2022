extends Node2D

export(float) var lifetime = 2
export(int) var rise_distance = 100
export(int) var damage = 1 setget set_damage

var tween


func _ready():
    global_rotation_degrees = 0
    start()


func start():
    tween = Tween.new()
    add_child(tween)

    var target = position + rise_distance * Vector2.UP

    tween.interpolate_property(
        self, "position",
        position, target, lifetime,
        Tween.TRANS_QUART, Tween.EASE_OUT)
    tween.interpolate_property(
        self, "scale",
        Vector2.ZERO, Vector2.ONE, 0.5 * lifetime,
        Tween.TRANS_ELASTIC, Tween.EASE_OUT)
    tween.interpolate_property(
        self, "modulate:a",
        1, 0, lifetime,
        Tween.TRANS_QUAD, Tween.EASE_OUT)
    tween.start()

    yield(tween, "tween_all_completed")
    queue_free()


func set_damage(value):
    damage = value

    $Label.text = str(-damage)
