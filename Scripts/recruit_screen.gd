extends Control

const CreatureDatabase = preload("res://Scripts/Data/creature_database.gd")
const AttackDatabase = preload("res://Scripts/Data/attack_database.gd")
const MAIN_FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")
const UISkin = preload("res://Scripts/ui_skin.gd")

var selected_recruit = ""

var info_popup: Panel
var pokemon_sprite: TextureRect
var pokemon_name: Label
var pokemon_type: Label
var pokemon_hp: Label
var attack_labels = []
var tips_label: Label


func _ready():

	get_tree().paused = false

	fix_root_layout()
	hide_old_nodes()
	build_recruit_screen()


func fix_root_layout():

	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1

	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0


func hide_old_nodes():

	var old_nodes = [
		"Label",
		"Escolha1",
		"Escolha2"
	]

	for node_name in old_nodes:

		var node = get_node_or_null(node_name)

		if node:

			node.visible = false

			if node is Button:
				node.disabled = true


func build_recruit_screen():

	if GameData.recruit_options.is_empty():

		start_next_dialogue()

		return
	
	var background = TextureRect.new()
	background.texture = load("res://Assets/Sprites/fundo_starter.png")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(background)

	var title = create_label(
		"Você venceu! Escolha uma criatura para recrutar",
		Vector2(0, 40),
		Vector2(1280, 60),
		34
	)
	add_child(title)
	
	UISkin.apply_screen_title(title, 32)
	
	var subtitle = create_label(
		"Clique em uma criatura para ver detalhes antes de escolher.",
		Vector2(0, 100),
		Vector2(1280, 40),
		18
	)
	add_child(subtitle)
	
	UISkin.apply_screen_title(subtitle, 16)
	
	var cards_container = HBoxContainer.new()
	cards_container.anchor_left = 0.5
	cards_container.anchor_top = 0.5
	cards_container.anchor_right = 0.5
	cards_container.anchor_bottom = 0.5
	cards_container.offset_left = -380
	cards_container.offset_top = -120
	cards_container.offset_right = 380
	cards_container.offset_bottom = 230
	cards_container.add_theme_constant_override("separation", 60)
	add_child(cards_container)

	for creature_id in GameData.recruit_options:

		add_creature_card(
			cards_container,
			creature_id
		)

	build_info_popup()


func add_creature_card(parent, creature_id):

	var creature = CreatureDatabase.CREATURES[creature_id]

	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(320, 360)
	parent.add_child(card)
	UISkin.apply_slot_style(card)

	var box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	card.add_child(box)

	var sprite = TextureRect.new()
	sprite.texture = load(creature["sprite"])
	sprite.custom_minimum_size = Vector2(260, 180)
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	box.add_child(sprite)

	var name_label = Label.new()
	name_label.text = creature["name"]
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_override("font", MAIN_FONT)
	name_label.add_theme_font_size_override("font_size", 24)
	UISkin.apply_dark_label(name_label, 22)
	box.add_child(name_label)

	var type_label = Label.new()
	type_label.text = "Tipo: " + creature["type"].capitalize()
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.add_theme_font_override("font", MAIN_FONT)
	type_label.add_theme_font_size_override("font_size", 18)
	type_label.add_theme_color_override("font_color", get_type_color(creature["type"]))
	type_label.add_theme_color_override("font_outline_color", Color("#3B2416"))
	type_label.add_theme_constant_override("outline_size", 2)
	box.add_child(type_label)

	var hp_label = Label.new()
	hp_label.text = "HP: " + str(creature["max_hp"])
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UISkin.apply_dark_label(hp_label, 15)
	box.add_child(hp_label)

	var details_button = Button.new()
	details_button.text = "Ver detalhes"
	details_button.custom_minimum_size = Vector2(220, 45)
	details_button.add_theme_font_override("font", MAIN_FONT)
	details_button.add_theme_font_size_override("font_size", 16)
	UISkin.apply_travel_button(details_button, 15)
	box.add_child(details_button)

	details_button.pressed.connect(
		open_creature_popup.bind(creature_id)
	)


func build_info_popup():

	info_popup = Panel.new()
	info_popup.visible = false
	info_popup.anchor_left = 0.5
	info_popup.anchor_top = 0.5
	info_popup.anchor_right = 0.5
	info_popup.anchor_bottom = 0.5
	info_popup.offset_left = -560
	info_popup.offset_top = -285
	info_popup.offset_right = 560
	info_popup.offset_bottom = 285
	UISkin.apply_panel_style(info_popup)
	add_child(info_popup)

	pokemon_sprite = TextureRect.new()
	pokemon_sprite.position = Vector2(70, 30)
	pokemon_sprite.size = Vector2(260, 180)
	pokemon_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	info_popup.add_child(pokemon_sprite)

	pokemon_name = create_label(
		"",
		Vector2(390, 25),
		Vector2(350, 40),
		28
	)
	info_popup.add_child(pokemon_name)

	pokemon_type = create_label(
		"",
		Vector2(390, 70),
		Vector2(350, 32),
		20
	)
	info_popup.add_child(pokemon_type)

	pokemon_hp = create_label(
		"",
		Vector2(390, 105),
		Vector2(350, 32),
		18
	)
	info_popup.add_child(pokemon_hp)

	attack_labels.clear()

	var attack_positions = [
		Vector2(80, 240),
		Vector2(430, 240),
		Vector2(780, 240)
	]

	for pos in attack_positions:

		var attack_label = create_label(
			"",
			pos,
			Vector2(270, 160),
			15
		)

		info_popup.add_child(attack_label)
		attack_labels.append(attack_label)

	tips_label = create_label(
		"",
		Vector2(90, 425),
		Vector2(940, 55),
		16
	)
	info_popup.add_child(tips_label)

	var back_button = Button.new()
	back_button.text = "Voltar"
	back_button.position = Vector2(270, 510)
	back_button.size = Vector2(180, 40)
	back_button.add_theme_font_override("font", MAIN_FONT)
	UISkin.apply_slot_button(back_button, 15)
	info_popup.add_child(back_button)

	back_button.pressed.connect(close_popup)

	var confirm_button = Button.new()
	confirm_button.text = "Recrutar"
	confirm_button.position = Vector2(670, 510)
	confirm_button.size = Vector2(180, 40)
	confirm_button.add_theme_font_override("font", MAIN_FONT)
	UISkin.apply_travel_button(confirm_button, 15)
	info_popup.add_child(confirm_button)

	confirm_button.pressed.connect(confirm_recruit)


func create_label(text_value, label_position, label_size, font_size):

	var label = Label.new()

	label.text = text_value
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", MAIN_FONT)
	label.add_theme_font_size_override("font_size", font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UISkin.apply_dark_label(label, font_size)

	return label


func open_creature_popup(creature_id):

	selected_recruit = creature_id

	var creature = CreatureDatabase.CREATURES[creature_id]

	pokemon_sprite.texture = load(creature["sprite"])
	pokemon_name.text = creature["name"]
	pokemon_type.text = "Tipo: " + creature["type"].capitalize()
	pokemon_type.modulate = get_type_color(creature["type"])
	pokemon_hp.text = "HP: " + str(creature["max_hp"])

	for i in range(attack_labels.size()):

		if i >= creature["attacks"].size():

			attack_labels[i].text = ""

			continue

		var attack_id = creature["attacks"][i]
		var attack = AttackDatabase.ATTACKS[attack_id]

		attack_labels[i].text = (
			"[ " + attack["name"] + " ]\n\n" +
			"Dano: " + str(attack["damage"]) + "\n" +
			"Cooldown: " + str(attack["cooldown"]) + "s\n" +
			"Tipo: " + attack["type"].capitalize() + "\n" +
			"Efeito: " + get_effect_description(attack["effect"])
		)

	tips_label.text = get_creature_tip(creature_id)

	info_popup.visible = true


func close_popup():

	info_popup.visible = false
	selected_recruit = ""


func confirm_recruit():

	if selected_recruit == "":
		return

	if not GameData.player_team.has(selected_recruit):

		GameData.player_team.append(
			selected_recruit
		)

	print("==================")
	print("CRIATURA RECRUTADA:")
	print(selected_recruit)
	print("TIME PLAYER:")
	print(GameData.player_team)

	GameData.recruit_options.clear()

	start_next_dialogue()


func get_effect_description(effect):

	match effect:

		"burn":
			return "Queimadura"

		"freeze":
			return "Congelamento"

		"paralyze":
			return "Paralisia"

		_:
			return "Nenhum"


func get_creature_tip(creature_id):

	var creature = CreatureDatabase.CREATURES[creature_id]

	match creature["type"]:

		"fogo":
			return "Dica: criaturas de fogo são fortes contra planta."

		"água":
			return "Dica: criaturas de água são fortes contra fogo."

		"planta":
			return "Dica: criaturas de planta são fortes contra água."

		"normal":
			return "Dica: criaturas normais são boas contra elementais."

		"elemental":
			return "Dica: elementais são fortes contra fogo, água e planta, mas sofrem contra normal."

		_:
			return ""


func get_type_color(type_name):

	match type_name:

		"fogo":
			return Color("#FF5555")

		"água":
			return Color("#4AA3FF")

		"planta":
			return Color("#55CC55")

		"normal":
			return Color("#DDDDDD")

		"elemental":
			return Color("#B35CFF")

		_:
			return Color.WHITE


func start_next_dialogue():

	GameData.battle_number += 1

	if GameData.battle_number >= GameData.total_battles:

		GameData.became_master = true

		get_tree().change_scene_to_file(
			"res://Scenes/VictoryScreen.tscn"
		)

		return

	setup_next_enemy_dialogue()

	get_tree().change_scene_to_file(
		"res://Scenes/EnemyDialogueScreen.tscn"
	)


func setup_next_enemy_dialogue():

	match GameData.battle_number:

		1:
			GameData.current_enemy_sprite = (
				"res://Assets/Sprites/guy1.png"
			)

			GameData.current_enemy_dialogue = [

				"Interessante... Você venceu aquele novato.",

				"Mas eu sou muito mais forte! Vamos descobrir quem merece ser Mestre!"
			]

		2:
			GameData.current_enemy_sprite = (
				"res://Assets/Sprites/girl3.png"
			)

			GameData.current_enemy_dialogue = [

				"Você está melhorando rápido... então vou aumentar o desafio.",

				"A partir daqui, você vai conhecer criaturas elementais.",

				"Elas não seguem as regras comuns dos tipos básicos. Prepare-se!"
			]

		3:
			GameData.current_enemy_sprite = (
				"res://Assets/Sprites/guy1.png"
			)

			GameData.current_enemy_dialogue = [

				"Você já entendeu os elementais, mas não subestime o tipo normal.",

				"Criaturas normais parecem simples, mas podem ser a resposta contra elementais.",

				"Agora será uma batalha quatro contra quatro!"
			]

		4:
			GameData.current_enemy_sprite = (
				"res://Assets/Sprites/girl1.png"
			)

			GameData.current_enemy_dialogue = [

				"Chegamos à última batalha.",

				"Minha equipe tem uma criatura de cada tipo.",

				"Fogo, água, planta, normal e elemental. Mostre que você domina todos eles!"
			]

		_:
			GameData.current_enemy_sprite = (
				"res://Assets/Sprites/girl1.png"
			)

			GameData.current_enemy_dialogue = [

				"Prepare-se para a próxima batalha!"
			]


# Essas duas funções ficam aqui só para não dar erro nas conexões antigas da cena.
func _on_escolha_1_pressed():

	if GameData.recruit_options.size() > 0:
		open_creature_popup(GameData.recruit_options[0])


func _on_escolha_2_pressed():

	if GameData.recruit_options.size() > 1:
		open_creature_popup(GameData.recruit_options[1])
