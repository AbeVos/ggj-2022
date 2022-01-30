extends AudioStreamPlayer2D

onready var tween = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE
var out = true

func _ready():
    fade_in()

func fade_out():
    tween.interpolate_property(
        self, "volume_db",
        0, -80, transition_duration,
        transition_type, Tween.EASE_IN, 0)
    tween.start()
    out = !out


func _on_TweenOut_tween_completed(object, key):
    object.stop()


func fade_in():
    tween.interpolate_property(
        self, "volume_db",
        -80, 0, transition_duration,
        transition_type, Tween.EASE_OUT, 0)
    tween.start()
    out = !out
