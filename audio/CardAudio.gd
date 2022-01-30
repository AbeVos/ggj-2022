extends AudioStreamPlayer

var sounds=[]

func _ready():
    randomize()
    sounds.append(preload("res://audio/sounds/card_drop_01.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_02.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_03.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_04.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_05.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_06.wav"))

func sounds_random(s:Array) -> void:
    s.shuffle()
    stream=sounds.front()
    play()

func startgeluid():
    sounds_random(sounds)
    
func stopgeluid():
    stop()
