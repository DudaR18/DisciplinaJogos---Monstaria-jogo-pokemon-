extends Control

@onready var title = $CenterContainer/VBoxContainer/Title
@onready var restart_button = $CenterContainer/VBoxContainer/RestartButton

func setup(victory):
	if victory:
		title.text = "VOCÊ VENCEU!"
	else:
		title.text = "GAME OVER"

		restart_button.text = "Tentar Novamente"

func _ready():
	restart_button.pressed.connect(restart_game)

func restart_game():
	get_tree().reload_current_scene()
