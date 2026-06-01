extends Control

@onready var play_button = $CenterContainer/VBoxContainer/PlayButton
@onready var exit_button = $CenterContainer/VBoxContainer/ExitButton


func _ready():

	play_button.pressed.connect(start_game)
	exit_button.pressed.connect(exit_game)


func start_game():

	get_tree().change_scene_to_file(
		"res://Scenes/Battle.tscn"
	)


func exit_game():

	get_tree().quit()
