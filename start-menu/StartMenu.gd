extends Control

signal start_game

func _on_StartButton_button_down():
    emit_signal("start_game")
