extends Node2D
signal card_grabbed
signal card_released
signal card_placed

export(Resource) var card_resource

var dragging = false


func _input(event):
    if not dragging:
        return


func _on_Area_input_event(viewport, event, shape_idx):
    print(name)
