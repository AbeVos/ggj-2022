extends Node2D
class_name CardSlot

signal slot_occupied(this, card)
signal slot_freed(this, card)
signal slot_clicked(this, card)
signal slot_attacked

signal card_destroyed
signal attack_deflected

export var attack_distance = 200

var sleep_scene = preload("res://cards-sleep/SleepParticles.tscn")
var indicator_scene = preload("res://card-slots/DamageIndicator.tscn")

var card_tween
var attack_tween
var is_occupied := false
var is_bottom := true setget set_is_bottom


func _ready():
    card_tween = Tween.new()
    add_child(card_tween)

    attack_tween = Tween.new()
    add_child(attack_tween)


func occupy_slot(card):
    if is_occupied:
        push_error(name + " is already occupied!")

    var position = card.global_position
    var rotation = card.global_rotation_degrees

    is_occupied = true
    var card_parent = card.get_parent()
    card_parent.remove_child(card)

    var sleep = sleep_scene.instance()
    card.add_child(sleep)
    $Slot.add_child(card)

    card.global_position = position
    card.global_rotation_degrees = rotation

    card_tween.interpolate_property(
        card, "position",
        card.position, Vector2.ZERO, 1.0,
        Tween.TRANS_ELASTIC, Tween.EASE_OUT)
    card_tween.interpolate_property(
        card, "rotation_degrees",
        card.rotation_degrees, 0.0, 1.0,
        Tween.TRANS_ELASTIC, Tween.EASE_OUT)

    card_tween.start()

    yield(card_tween, "tween_all_completed")

    emit_signal("slot_occupied", self, card)


func set_is_bottom(value):
    is_bottom = value
    $DayIndicator.visible = is_bottom


func free_slot():
    if not is_occupied:
        push_error(name + " is not occupied, cannot be freed!")

    is_occupied = false
    var card = $Slot.get_children()[0]
    $Slot.remove_child(card)

    emit_signal("slot_freed", self, card)

    return card


func attack(long: bool = false):
    var distance = attack_distance
    if long:
        distance *= 2.0

    var target = -distance * Vector2.UP
    attack_tween.interpolate_property(
        $Slot, "position",
        Vector2.ZERO, target, 0.3,
        Tween.TRANS_BACK, Tween.EASE_IN)
    attack_tween.start()

    yield(attack_tween, "tween_all_completed")

    attack_tween.interpolate_property(
        $Slot, "position",
        target, Vector2.ZERO, 0.7,
        Tween.TRANS_ELASTIC, Tween.EASE_OUT)
    attack_tween.start()

    yield(attack_tween, "tween_all_completed")
    attack_tween.remove_all()

    emit_signal("slot_attacked")


func destroy_card():
    if not is_occupied:
        push_error("Slot is not occupied")

    yield(get_tree().create_timer(0.3), "timeout")

    var card = $Slot/CardFace
    card_tween.interpolate_property(
        card, "scale",
        card.scale, Vector2.ZERO, 0.7,
        Tween.TRANS_BACK, Tween.EASE_IN)
    card_tween.start()

    yield(card_tween, "tween_all_completed")
    card.queue_free()
    is_occupied = false
    emit_signal("card_destroyed")


func deflect_attack():
    if not is_occupied:
        push_error("Slot is not occupied")

    yield(get_tree().create_timer(0.3), "timeout")

    var card = $Slot/CardFace
    var target_scale = card.scale
    card_tween.interpolate_property(
        card, "scale",
        1.5 * target_scale, target_scale, 0.7,
        Tween.TRANS_ELASTIC, Tween.EASE_OUT)
    card_tween.start()

    yield(card_tween, "tween_all_completed")
    emit_signal("attack_deflected")


func damage_player(damage):
    # Display a damage indicator.
    var indicator = indicator_scene.instance()
    indicator.damage = damage
    add_child(indicator)


func _on_Area_input_event(_viewport, event, _shape_idx):
    if (
        event is InputEventMouseButton
        and event.pressed
        and event.button_index == 1
    ):
        if len($Slot.get_children()) == 1:
            var card = $Slot.get_children()[0]
            if not card.get_node("SleepParticles").isSleeping:
                emit_signal("slot_clicked", self, $Slot.get_children()[0])
        elif len($Slot.get_children()) > 1:
            push_error("Slot has more than one child.")
