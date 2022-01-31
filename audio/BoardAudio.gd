extends AudioStreamPlayer

var sounds=[]

func _ready():
    randomize()
    sounds.append(preload("res://audio/sounds/table_turn_01.wav"))
    sounds.append(preload("res://audio/sounds/table_turn_02.wav"))
    sounds.append(preload("res://audio/sounds/table_turn_03.wav"))

func random_sound():
    sounds.shuffle()
    stream = sounds.front()
    play()

func _on_Board_rotation_started():
    random_sound()
    
func _on_Board_rotation_complete():
    stop()
