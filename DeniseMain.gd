extends Node

signal win
signal defeat

var current_player_health
var current_opponent_health

export var max_player_health = 5
export var max_opponent_health = 5

func _ready():
    current_player_health = max_player_health
    current_opponent_health = max_opponent_health
    
    $HUD.update_opponent_health(current_opponent_health)
    $HUD.update_player_health(current_player_health)

func damagePlayer(damage):
    if (current_player_health  > 0):
        current_player_health -= damage
        $HUD.update_player_health(current_player_health)
    if (current_player_health <= 0):
        emit_signal("win")
    
func damageOpponent(damage):
    if (current_opponent_health  > 0):
        current_opponent_health -= damage
        $HUD.update_opponent_health(current_opponent_health)
    if (current_opponent_health <= 0):
        emit_signal("defeat")


func _on_DamagePlayer_button_down():
    damagePlayer(1)


func _on_DamageOpponent_button_down():
    damageOpponent(1)
