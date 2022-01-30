extends Resource

const DATA_FILE_PATH = "res://data/deck.json"

var deck_data

func _init():
    load_data()


func load_data():
    var file = File.new()

    if not file.file_exists(DATA_FILE_PATH):
        push_error("Card data not found")

    file.open(DATA_FILE_PATH, file.READ)
    var contents = file.get_as_text()
    deck_data = parse_json(contents)
    file.close()

    if not validate_cards():
        push_error("Card data not valid")


func validate_cards():
    return len(deck_data) > 1 and typeof(deck_data[0]) == TYPE_STRING
