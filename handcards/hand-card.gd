extends Node2D
class_name HandCard

export(Resource) var card_resource setget set_resource

var hand
var active = false
var clicked = false
var dragging = false
var target = Vector2.ZERO


func _ready():
    $Area.visible = false


func _process(delta):
    if dragging:
        global_position = lerp(global_position, target, 10.0 * delta)


func _input(event):
    if (
        event is InputEventMouseButton
        and not event.pressed
        and event.button_index == 1
        and dragging
        and clicked
    ): # Left mouse released.
        clicked = false
        dragging = false

        # If card is over an empty slot, move it to the slot.
        var target_slot = find_closest_slot()

        if target_slot != null:
            target_slot.occupy_slot($Sprite)

            # call_deferred("queue_free")
            call_deferred("free")
        else:
            # Otherwise, return it to the hand.
            var offset = hand.get_node("Cards").curve.get_closest_offset(
                self.global_position)
            self.get_parent().remove_child(self)
            hand.add_card(self, offset)
    elif event is InputEventMouseMotion and dragging:
        target = event.position


func _on_Area_area_entered(area: Area2D):
    if area.get_parent() is CardSlot:
        pass


func _on_Area_area_exited(area: Area2D):
    if area.get_parent() is CardSlot:
        pass


func _on_Area_input_event(_viewport, _event, _shape_idx):
    # Only called when the mouse is in the area.
    if not clicked:
        return

    if not dragging:
        dragging = true

        hand.release_card(self)
        # TODO: Release card from hand.


func set_resource(value):
    card_resource = value

    # TODO: Update sprite etc.


func activate():
    $Area.visible = true


func deactivate():
    $Area.visible = false
    clicked = false
    dragging = false


func find_closest_slot():
    var areas = $Area.get_overlapping_areas()

    if len(areas) == 0:
        return

    var smallest_dist = INF
    var target_slot = null

    for area in areas:
        if not area.get_parent() is CardSlot:
            continue

        var slot = area.get_parent()

        if slot.is_occupied:
            continue

        var distance = global_position.distance_squared_to(
            slot.global_position)

        if distance < smallest_dist:
            smallest_dist = distance
            target_slot = slot

    return target_slot


func on_click():
    if $Area.visible:
        clicked = true
        print("Clicked ", name)
