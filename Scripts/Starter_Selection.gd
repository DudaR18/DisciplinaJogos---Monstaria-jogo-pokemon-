extends Control

func _on_aquary_button_pressed():

	GameData.selected_creature = "aquary"

	GameData.player_team.clear()

	GameData.player_team.append(
		"aquary"
	)

	start_battle()

func _on_flameling_button_pressed():

	GameData.selected_creature = "flameling"

	GameData.player_team.clear()

	GameData.player_team.append(
		"flameling"
	)

	start_battle()

func _on_leafbat_button_pressed():

	GameData.selected_creature = "leafbat"

	GameData.player_team.clear()

	GameData.player_team.append(
		"leafbat"
	)

	start_battle()

func start_battle():

	GameData.current_enemy_sprite = (
		"res://Assets/Sprites/girl1.png"
	)

	GameData.current_enemy_dialogue = [

		"Então você escolheu sua primeira criatura? Vamos ver se ela é forte mesmo!",

		"Prepare-se para batalhar!"
	]

	get_tree().change_scene_to_file(
		"res://Scenes/EnemyDialogueScreen.tscn"
	)
