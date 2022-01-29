extends Node
    
onready var tween = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE
var out = true

func fade_met_knop():
    if(out):
        fade_out($BackgroundMusic)
    else:
        fade_in($BackgroundMusic)

func fade_out(stream_player):
        print("out")
        tween.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
        tween.start()
        out = !out

func _on_TweenOut_tween_completed(object, key):
    # stop the music -- otherwise it continues to run at silent volume
    object.stop()
    object.volume_db = 0 # reset volume
    
func fade_in(stream_player):
    # tween music volume down to 0
    print("in")
    tween.interpolate_property(stream_player, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_OUT, 0)
    tween.start()
    out = !out
