extends Resource

signal cards_loaded_and_valid()

const DATA_FILE_PATH = "res://data/deck.json"

var card_data
var is_valid := false

func _init():
    load_data()


func load_data():
    var file = File.new()

    if not file.file_exists(DATA_FILE_PATH):
        push_error("Card data not found")

    file.open(DATA_FILE_PATH, file.READ)
    var contents = file.get_as_text()
    card_data = parse_json(contents)
    validate_cards()
    file.close()

    emit_signal("cards_loaded_and_valid")

func validate_cards():
    var keys = card_data.keys()
    var card = card_data[keys[0]]

    return true
    #is_valid = typeof(card.attack_day_value) == TYPE_INT and typeof(card.name) == TYPE_STRING
