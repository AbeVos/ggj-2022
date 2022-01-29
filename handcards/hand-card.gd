extends Node2D
class_name HandCard
signal card_grabbed(this)
signal card_released
signal card_placed

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
    ): # Left mouse released.
        clicked = false
        dragging = false

        var offset = hand.get_node("Cards").curve.get_closest_offset(
            self.global_position)
        self.get_parent().remove_child(self)
        hand.add_card(self, offset)

        # TODO: If card is over an empty slot, move it to the slot.
        # TODO: Otherwise, return it to the hand.
    elif event is InputEventMouseMotion and dragging:
        target = event.position


func _on_Area_input_event(_viewport, _event, _shape_idx):
    # Only called when the mouse is in the area.
    if not clicked:
        return

    if not dragging:
        dragging = true

        hand.release_card(self)
        # TODO: Release card from hand.

    # TODO: Check if mouse is pressed and start dragging the card.

    # TODO: While dragging, move the card to the cursor.

    # TODO: If, while dragging, the mouse is released, check if the area
    # collides with an area of the playing board. If not, return the card to
    # the hand.


func set_resource(value):
    card_resource = value

    # TODO: Update sprite etc.


func activate():
    $Area.visible = true


func on_click():
    clicked = true
    print("Clicked ", name)
