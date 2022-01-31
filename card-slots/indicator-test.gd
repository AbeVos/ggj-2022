extends Node2D

var indicator_scene = preload("res://card-slots/DamageIndicator.tscn")


func _ready():
    damage()


func damage():
    while true:
        var indicator = indicator_scene.instance()
        var position = Vector2(
            rand_range(0, get_viewport().size.x),
            rand_range(0, get_viewport().size.y))
        print(position)
        indicator.position = position
        indicator.damage = randi() % 10
        add_child(indicator)

        yield(get_tree().create_timer(rand_range(0.2, 0.8)), "timeout")


func _input(event):
    if (
        event is InputEventMouseButton
        and event.pressed
    ):
        var indicator = indicator_scene.instance()
        indicator.position = event.position
        indicator.damage = randi() % 10
        add_child(indicator)
