extends Resource

const DATA_FILE_PATH = "res://data/cards.json"

var card_data

func _init():
    load_data()


func load_data():
    var file = File.new()

    if not file.file_exists(DATA_FILE_PATH):
        push_error("Card data not found")

    file.open(DATA_FILE_PATH, file.READ)
    var contents = file.get_as_text()
    card_data = parse_json(contents)
    file.close()

    if not validate_cards():
        push_error("Card data not valid")


func validate_cards():
    var keys = card_data.keys()
    var card = card_data[keys[0]]

    return typeof(card.attack_day_value) == TYPE_INT and typeof(card.name) == TYPE_STRING
