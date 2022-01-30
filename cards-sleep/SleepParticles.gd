extends CPUParticles2D

export var turnsToSleep = 4
var isSleeping = true


func handleTurnsToSleep():
    if isSleeping:
        turnsToSleep -= 1
        print("Turns to sleep ", turnsToSleep)
        if turnsToSleep <= 0:
            isSleeping = false
            set_emitting(false)
