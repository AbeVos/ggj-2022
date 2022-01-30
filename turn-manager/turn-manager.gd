extends Node

const NEXT_ACTION_PRINT = "Next action %s, %s"

signal next_action(turn, player)
signal next_turn(player)

export(int) var num_players = 2
export(Array, String) var turn_actions: Array = [
    "start", "draw", "place", "select", "attack", "check", "rotate", "end"]

var current_player = -1
var current_action_idx = 0


func _ready():
    next_turn()


func _on_action_ended(action: String, result: Dictionary = {}):
    var action_idx = turn_actions.find(action, 0)

    if current_action_idx != action_idx:
        push_error(
            "Incorrect action "
            + action
            + ". Something is wrong. "
            + str(result))
        return

    # TODO: Handle result.
    if action == "check":
        var winner = result.get("winner")

        if winner != null:
            print("PLAYER ", winner, " HAS WON!")

            return

    var skipped = result.get("skipped", false)

    if skipped:
        print("Action skipped")

    next_action()


func next_action():
    current_action_idx += 1

    if current_action_idx >= len(turn_actions):
        next_turn()
    else:
        print(NEXT_ACTION_PRINT%[
            turn_actions[current_action_idx],
            current_player])
        emit_signal(
            "next_action", turn_actions[current_action_idx], current_player)


func next_turn():
    current_action_idx = -1
    current_player = (current_player + 1) % num_players

    print("Next turn ", current_player)
    emit_signal("next_turn", current_player)

    call_deferred("next_action")
