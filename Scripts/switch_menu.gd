extends Control

func _ready():

	var close_button = get_node(
		"CenterContainer/Panel/VBoxContainer/CloseButton"
	)

	close_button.pressed.connect(close_menu)

func close_menu():

	queue_free()
