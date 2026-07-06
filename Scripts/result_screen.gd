extends Control

const UISkin = preload("res://Scripts/ui_skin.gd")

@onready var title = $CenterContainer/VBoxContainer/Title
@onready var restart_button = $CenterContainer/VBoxContainer/RestartButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/MainMenuButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

func setup(victory):
	
	apply_ui_skin()
	
	if victory:

		if GameData.demo_finished:
			
			get_tree().paused = false
			
			title.text = (
				"PARABÉNS! Você concluiu todas as batalhas implementadas até o momento. A jornada ainda está em desenvolvimento!"
			)

		elif GameData.became_master:

			title.text = (
				"VOCÊ SE TORNOU UM MESTRE DAS CRIATURAS!"
			)

		else:

			title.text = "VOCÊ VENCEU!"

	else:

		title.text = (
			"FIM DE JOGO:\nVOCÊ PERDEU A BATALHA"
		)

		restart_button.text = "Tentar Novamente"
		
func _ready():

	if GameData.demo_finished:

		setup(true)

	elif GameData.became_master:

		setup(true)

	restart_button.pressed.connect(restart_game)
	main_menu_button.pressed.connect(go_to_main_menu)
	quit_button.pressed.connect(quit_game)

func restart_game():

	get_tree().paused = false

	GameData.player_team.clear()
	GameData.enemy_team.clear()
	GameData.recruit_options.clear()

	GameData.selected_creature = ""

	GameData.battle_number = 0
	GameData.player_index = 0
	GameData.enemy_index = 0

	GameData.demo_finished = false
	GameData.became_master = false
	GameData.first_battle_tip_shown = false
	GameData.elemental_tip_shown = false
	GameData.result_victory = false

	get_tree().change_scene_to_file(
		"res://Scenes/StarterSelection.tscn"
	)

func go_to_main_menu():

	get_tree().paused = false

	GameData.first_battle_tip_shown = false
	GameData.elemental_tip_shown = false

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu.tscn"
	)

func quit_game():
	get_tree().quit()

func apply_ui_skin():

	# Procura painéis principais da tela.
	var possible_panels = [
		"Panel",
		"ResultPanel",
		"CenterContainer/Panel",
		"VBoxContainer",
		"CenterContainer/VBoxContainer"
	]

	for path in possible_panels:

		var node = get_node_or_null(path)

		if node and node is Control:
			UISkin.apply_panel_style(node)

	# Aplica estilo em todos os botões da tela.
	apply_skin_to_buttons(self)

	# Aplica estilo em todos os textos da tela.
	apply_skin_to_labels(self)


func apply_skin_to_buttons(node):

	for child in node.get_children():

		if child is Button:
			UISkin.apply_travel_button(child, 16)

		apply_skin_to_buttons(child)


func apply_skin_to_labels(node):

	for child in node.get_children():

		if child is Label:

			if child.text.to_upper().contains("FIM") or child.text.to_upper().contains("VITÓRIA"):
				UISkin.apply_screen_title(child, 34)
			else:
				UISkin.apply_light_label(child, 17)

		apply_skin_to_labels(child)
