extends Node2D

signal action_ended(turn, result)
signal new_angle(angle)
signal rotation_complete

signal player_attacked(player, damage)

var slot_scene = preload("res://card-slots/CardSlot.tscn")
var card_db = preload("res://data/cards.tres")

export(int) var sectors = 4  # Number of card slots on each side.
export(float) var radius = 150.0
export(float, 0, 5) var rotation_duration = 2.0

var tween
var angle = 0
var player_attacking = false
var card_list = []
var card_data
var is_day = [true, true, true, true, false, false, false, false]


func _ready():
    tween = Tween.new()
    add_child(tween)

    for sector in range(2 * sectors):
        var slot = slot_scene.instance()
        slot.get_node("Label").text = str(sector)

        $Slots.add_child(slot)
        slot.connect("slot_occupied", self, "_on_CardSlot_slot_occupied")
        slot.connect("slot_clicked", self, "_on_CardSlot_slot_clicked")

        var angle_offset = (
            360.0 / (2 * sectors)  # Angle of a sector.
            * (sector + 0.5)  # Sector index offset + halfsector offset.
        )
        slot.position = radius * Vector2(
            cos(deg2rad(angle_offset)),
            sin(deg2rad(angle_offset)))
        slot.rotation_degrees = angle_offset + 90

    card_data = card_db.card_data


func rotate_board(turns: int):
    var clockwise = turns > 0
    for _idx in range(abs(turns)):
        single_rotation(clockwise)
        yield(tween, "tween_all_completed")

        angle = (angle + sign(turns)) % (2 * sectors)
        emit_signal("new_angle", angle)
        print("New angle ", angle)

    for idx in range(2 * sectors):
        var _is_bottom = slot_is_bottom(idx)
        var _slot = $Slots.get_children()[idx]

        # TODO: Update bottom status.


    emit_signal("rotation_complete")


func single_rotation(clockwise: bool):
    var angle_degrees = 360.0 / (2 * sectors)

    if not clockwise:
        angle_degrees = -angle_degrees

    tween.interpolate_property(
        self, "rotation_degrees",
        rotation_degrees, rotation_degrees + angle_degrees, rotation_duration,
        Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
    tween.start()


func slot_is_bottom(slot: int) -> bool:
    return (slot + angle) % (2 * sectors) < sectors


func get_card_in_slot(idx: int):
    var slot = $Slots.get_children()[idx].get_node("Slot")

    if len(slot.get_children()) == 1:
        return slot.get_children()[0]

    return null


func player_can_attack() -> bool:
    for idx in range(2 * sectors):
        if not slot_is_bottom(idx):
            continue

        var card = get_card_in_slot(idx)

        if card == null:
            continue

        if not card.get_node("SleepParticles").isSleeping:
            return true

    return false


func opponent_can_attack() -> bool:
    for idx in range(2 * sectors):
        if slot_is_bottom(idx):
            continue

        var card = get_card_in_slot(idx)

        if card == null:
            continue

        if not card.get_node("SleepParticles").isSleeping:
            return true

    return false


func perform_opponent_attack():
    var from = (angle + sectors) % (2 * sectors)
    var to = (angle + 2 * sectors) % (2 * sectors)

    var indices = []

    for idx in range(to, from):
        # idx = from + idx
        print(idx)

        var card = get_card_in_slot(idx)

        if card != null:
            var is_sleeping = card.get_node("SleepParticles").isSleeping
            if not is_sleeping:
                indices.append(idx)

    if len(indices) == 0:
        emit_signal("action_ended", "attack", {"skipped": true})
    else:
        var select = indices[randi() % len(indices)]
        var slot = $Slots.get_children()[select]

        attack(select)
        slot.attack()
        yield(slot, "slot_attacked")

        emit_signal("action_ended", "attack", {})


func attack(attacker_index: int):
    # var attacker_index = card_list.find(attacking_card)
    var opponent_index = (
        (attacker_index + sectors)
        % (2 * sectors))

    var attacking_card = get_card_in_slot(attacker_index)
    var opponent_card = get_card_in_slot(opponent_index)

    if attacking_card == null:
        push_error("There is no attacking card")

    if opponent_card == null:
        # Attack opponent.
        emit_signal("player_attacked", 1, attacking_card.attack_day)
        return

    # Handel hier de abillities af

    # verediging - aanval
    var attack_result = 0

    if slot_is_bottom(attacker_index):
        attack_result = (
            opponent_card.defence_night - attacking_card.attack_day)

        emit_signal("player_attacked", 1, attack_result)

    else:
        attack_result = (
            opponent_card.defence_day - attacking_card.attack_night)
        emit_signal("player_attacked", 0, attack_result)


func _on_Root_next_action(turn, player):
    player_attacking = false

    match turn:
        "rotate":
            rotate_board(1)

            yield(self, "rotation_complete")

            emit_signal("action_ended", turn, {})
        "place":
            if player > 0:
                emit_signal("action_ended", turn, {"skipped": true})
        "attack":
            print("Can opponent attack? ", opponent_can_attack())
            if player == 0 and player_can_attack():
                player_attacking = true
            elif player > 0 and opponent_can_attack():
                # TODO: Select random card and attack.
                perform_opponent_attack()
            else:
                emit_signal("action_ended", turn, {"skipped": true})


func _on_Root_next_turn(player):
    for idx in range(2 * sectors):
        var card = get_card_in_slot(idx)

        if card == null:
            continue

        print("Update sleep")
        card.get_node("SleepParticles").handleTurnsToSleep()


func _on_CardSlot_slot_occupied(slot, card):
    emit_signal("action_ended", "place", {"slot": slot, "card": card})


func _on_CardSlot_slot_clicked(slot, _card):
    if not player_attacking:
        return

    var idx = $Slots.get_children().find(slot)

    print(slot_is_bottom(idx))

    if slot_is_bottom(idx):
        print("Attack!")
        attack(idx)
        slot.attack()

        yield(slot, "slot_attacked")

        emit_signal("action_ended", "attack", {})
