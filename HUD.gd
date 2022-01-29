extends Control

func update_player_health(health):
    $PlayerHp.text = str(health)

func update_opponent_health(health):
    $OpponentHp.text = str(health)
