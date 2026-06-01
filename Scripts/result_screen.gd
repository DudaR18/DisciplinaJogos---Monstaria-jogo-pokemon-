extends Control

@onready var title = $CenterContainer/VBoxContainer/Title
@onready var restart_button = $CenterContainer/VBoxContainer/RestartButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/MainMenuButton

func setup(victory):
	if victory:
		title.text = "VOCÊ VENCEU!"
	else:
		title.text = "FIM DE JOGO: VOCÊ PERDEU A BATALHA"

		restart_button.text = "Tentar Novamente"

func _ready():
	restart_button.pressed.connect(restart_game)
	main_menu_button.pressed.connect(go_to_main_menu)

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func go_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu.tscn"
	)
