extends Control

@onready var option1 = $Escolha1
@onready var option2 = $Escolha2

func _ready():

	print("============================================")
	print("RECRUIT:", GameData.recruit_options)
	
	option1.text = GameData.recruit_options[0]
	option2.text = GameData.recruit_options[1]
	
func _on_flameling_button_pressed():

	GameData.player_team.append("flameling")

	start_next_battle()


func _on_leafbat_button_pressed():

	GameData.player_team.append("leafbat")

	start_next_battle()


func start_next_battle():

	GameData.battle_number += 1

	if GameData.battle_number >= GameData.enemy_battles.size():

		GameData.became_master = true

		get_tree().change_scene_to_file(
			"res://Scenes/ResultScreen.tscn"
		)

		return

	get_tree().change_scene_to_file(
		"res://Scenes/Battle.tscn"
	)

func _on_escolha_1_pressed():

	GameData.player_team.append(
		GameData.recruit_options[0]
	)
	
	print("==================")
	print("TIME PLAYER:")
	print(GameData.player_team)

	start_next_dialogue()
	
func _on_escolha_2_pressed():

	GameData.player_team.append(
		GameData.recruit_options[1]
	)

	print("==================")
	print("TIME PLAYER:")
	print(GameData.player_team)
	
	start_next_dialogue()
	
func start_next_dialogue():

	GameData.battle_number += 1

	if GameData.battle_number >= 2:

		get_tree().change_scene_to_file(
			"res://Scenes/VictoryScreen.tscn"
		)

		return

	if GameData.battle_number == 1:

		GameData.current_enemy_sprite = (
			"res://Assets/Sprites/guy1.png"
		)

		GameData.current_enemy_dialogue = [

			"Interessante... Você venceu aquele novato.",

			"Mas eu sou muito mais forte! Vamos descobrir quem merece ser Mestre!"
		]

	get_tree().change_scene_to_file(
		"res://Scenes/EnemyDialogueScreen.tscn"
	)
