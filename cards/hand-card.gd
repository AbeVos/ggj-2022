extends Node2D
signal card_grabbed
signal card_released
signal card_placed

export(Resource) var card_resource setget set_resource

var dragging = false


func _on_Area_input_event(viewport, event, shape_idx):
    print(name)

    # TODO: Check if mouse is pressed and start dragging the card.

    # TODO: While dragging, move the card to the cursor.

    # TODO: If, while dragging, the mouse is released, check if the area
    # collides with an area of the playing board. If not, return the card to
    # the hand.


func set_resource(value):
    card_resource = value

    # TODO: Update sprite etc.
