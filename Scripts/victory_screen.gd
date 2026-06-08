extends Control

@onready var restart_button = $CenterContainer/VBoxContainer/RestartButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/MainMenuButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

func _ready():

	get_tree().paused = false

	restart_button.pressed.connect(restart_game)
	main_menu_button.pressed.connect(go_to_main_menu)
	quit_button.pressed.connect(quit_game)

func restart_game():

	GameData.player_team.clear()
	GameData.enemy_team.clear()
	GameData.recruit_options.clear()

	GameData.selected_creature = ""

	GameData.battle_number = 0
	GameData.player_index = 0
	GameData.enemy_index = 0

	GameData.demo_finished = false
	GameData.became_master = false

	get_tree().change_scene_to_file(
		"res://Scenes/StarterSelection.tscn"
	)

func go_to_main_menu():

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu.tscn"
	)

func quit_game():

	get_tree().quit()
