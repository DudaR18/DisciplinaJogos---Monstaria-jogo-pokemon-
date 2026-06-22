extends Control

signal creature_selected(creature_id)

@onready var title = $CenterContainer/Panel/VBoxContainer/Title
@onready var button1 = $CenterContainer/Panel/VBoxContainer/CreatureButton1
@onready var button2 = $CenterContainer/Panel/VBoxContainer/CreatureButton2
@onready var button3 = $CenterContainer/Panel/VBoxContainer/CreatureButton3
@onready var close_button = $CenterContainer/Panel/VBoxContainer/CloseButton

var buttons = []

func _ready():

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	buttons = [
		button1,
		button2,
		button3
	]

	setup_buttons()

	close_button.pressed.connect(close_menu)


func setup_buttons():

	title.text = "Trocar criatura"

	for i in range(buttons.size()):

		if i < GameData.player_team.size():

			var creature_id = GameData.player_team[i]

			buttons[i].visible = true
			buttons[i].text = creature_id.capitalize()

			buttons[i].pressed.connect(func(id = creature_id):
				select_creature(id)
			)

		else:

			buttons[i].visible = false


func select_creature(creature_id):

	creature_selected.emit(creature_id)

	queue_free()


func close_menu():

	queue_free()
