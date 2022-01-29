extends Node2D
class_name HandCard
signal card_grabbed
signal card_released
signal card_placed

export(Resource) var card_resource setget set_resource

var active = false
var clicked = false
var dragging = false
var target


func _ready():
    $Area.visible = false


func _process(delta):
    if dragging:
        position = (1 - delta) * position + delta * target


func _input(event):
    if (
        event is InputEventMouseButton
        and not event.pressed
        and event.button_index == 1
    ): # Left mouse released.
        clicked = false
        dragging = false

        # TODO: If card is over an empty slot, move it to the slot.
        # TODO: Otherwise, return it to the hand.


func _on_Area_input_event(_viewport, event, _shape_idx):
    if not clicked:
        return

    if not dragging:
        dragging = true
        # TODO: Release card from hand.

    target = event.position

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
