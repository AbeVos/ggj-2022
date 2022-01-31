extends AudioStreamPlayer

var sounds=[]

func _ready():
    sounds.append(preload("res://audio/sounds/card_drop_01.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_02.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_03.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_04.wav"))
    sounds.append(preload("res://audio/sounds/card_drop_05.wav"))
    # sounds.append(preload("res://audio/sounds/card_drop_06.wav"))

    randomize()

func random_sound():
    sounds.shuffle()
    stream = sounds.front()
    play()

func _on_CardSlot_card_placed():
	random_sound()
