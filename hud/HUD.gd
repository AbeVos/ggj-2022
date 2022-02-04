extends Control
signal action_ended(turn, result)


export(int) var player_health = 5 setget set_player_health
export(int) var opponent_health = 5 setget set_opponent_health


func _ready():
    $PlayerHealthBar.value = player_health
    $OpponentHealthBar.value = opponent_health


func damage_player(amount: int):
    player_health -= amount
    $PlayerHealthBar.value = player_health

func damage_opponent(amount: int):
    opponent_health -= amount
    $OpponentHealthBar.value = opponent_health


func set_player_health(value):
    player_health = value
    $PlayerHealthBar.value = player_health

func set_opponent_health(value):
    opponent_health = value
    $OpponentHealthBar.value = opponent_health


func _on_Root_next_action(turn, player):
    if turn != "check":
        return

    if opponent_health <= 0:
        emit_signal("action_ended", "check", {"winner": 0})
    elif player_health <= 0:
        emit_signal("action_ended", "check", {"winner": 1})
    else:
        print("No winner yet")
        emit_signal("action_ended", "check", {"skipped": true})


func _on_Board_player_attacked(player, damage):
    print("Attacked ", player, " for ", damage)
    if player == 0:
        damage_player(damage)
    elif player == 1:
        damage_opponent(damage)
