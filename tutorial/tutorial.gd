extends CenterContainer

var progress = 0


func _on_Root_next_action(turn, _player):
    visible = true

    for dialog in get_children():
        print(dialog.name)
        if turn == dialog.action:
            get_tree().paused = true
            dialog.popup()

            yield(dialog, "confirmed")
            dialog.queue_free()
            get_tree().paused = false

    visible = false
    print("Finished tutorial")

    if len(get_children()) == 0:
        queue_free()
