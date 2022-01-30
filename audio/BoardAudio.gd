extends AudioStreamPlayer

var sounds=[]

func _ready():
    randomize()
    sounds.append(preload("res://audio/sounds/table_turn_01.wav"))
    sounds.append(preload("res://audio/sounds/table_turn_02.wav"))
    sounds.append(preload("res://audio/sounds/table_turn_03.wav"))
    stream=sounds.front()
    play()

func sounds_random(s:Array) -> void:
    s.shuffle()
    stream=sounds.front()
    play()
