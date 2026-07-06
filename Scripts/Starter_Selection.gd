extends Control

const CreatureDatabase = preload("res://Scripts/Data/creature_database.gd")
const AttackDatabase = preload("res://Scripts/Data/attack_database.gd")
const MAIN_FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")
const UISkin = preload("res://Scripts/ui_skin.gd")

const STARTER_OPTIONS = [
	"aquary",
	"flameling",
	"leafbat"
]

var selected_preview_creature = ""

var info_popup: Panel
var popup_overlay: ColorRect
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
	build_starter_screen()


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
		"Text",
		"AquaryButton",
		"AquarySprite",
		"FlamelingButton",
		"FlamelingSprite",
		"LeafbatButton",
		"LeafbatSprite",
		"InfoPopup"
	]

	for node_name in old_nodes:

		var node = get_node_or_null(node_name)

		if node:

			node.visible = false

			if node is Button:
				node.disabled = true


func build_starter_screen():

	var background = TextureRect.new()
	background.texture = load("res://Assets/Sprites/fundo_starter.png")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(background)

	var dark_layer = ColorRect.new()
	dark_layer.color = Color(0, 0, 0, 0.35)
	dark_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dark_layer)

	var title = create_label(
		"Escolha sua primeira criatura!",
		Vector2(0, 45),
		Vector2(1280, 65),
		38
	)
	add_child(title)
	
	UISkin.apply_screen_title(title, 36)
	
	var subtitle = create_label(
		"Clique em uma criatura para ver seus detalhes antes de escolher.",
		Vector2(0, 105),
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
	cards_container.offset_left = -520
	cards_container.offset_top = -145
	cards_container.offset_right = 520
	cards_container.offset_bottom = 245
	cards_container.add_theme_constant_override("separation", 40)
	add_child(cards_container)

	for creature_id in STARTER_OPTIONS:

		add_creature_card(
			cards_container,
			creature_id
		)

	build_info_popup()


func add_creature_card(parent, creature_id):

	var creature = CreatureDatabase.CREATURES[creature_id]

	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(320, 390)
	parent.add_child(card)
	UISkin.apply_slot_style(card)

	var box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	card.add_child(box)

	var sprite = TextureRect.new()
	sprite.texture = load(creature["sprite"])
	sprite.custom_minimum_size = Vector2(280, 190)
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
	type_label.modulate = get_type_color(creature["type"])
	type_label.add_theme_font_override("font", MAIN_FONT)
	type_label.add_theme_font_size_override("font_size", 18)
	box.add_child(type_label)

	var hp_label = Label.new()
	hp_label.text = "HP: " + str(creature["max_hp"])
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_label.add_theme_font_override("font", MAIN_FONT)
	hp_label.add_theme_font_size_override("font_size", 16)
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

	popup_overlay = ColorRect.new()
	popup_overlay.visible = false
	popup_overlay.color = Color(0, 0, 0, 0.65)
	popup_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(popup_overlay)

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
	back_button.text = "Escolher outro"
	back_button.position = Vector2(245, 510)
	back_button.size = Vector2(210, 40)
	back_button.add_theme_font_override("font", MAIN_FONT)
	info_popup.add_child(back_button)

	back_button.pressed.connect(close_popup)

	var confirm_button = Button.new()
	confirm_button.text = "Confirmar escolha"
	confirm_button.position = Vector2(650, 510)
	confirm_button.size = Vector2(230, 40)
	confirm_button.add_theme_font_override("font", MAIN_FONT)
	info_popup.add_child(confirm_button)

	confirm_button.pressed.connect(confirm_starter)


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

	selected_preview_creature = creature_id

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

	popup_overlay.visible = true
	info_popup.visible = true


func close_popup():

	info_popup.visible = false
	popup_overlay.visible = false
	selected_preview_creature = ""


func confirm_starter():

	if selected_preview_creature == "":
		return

	GameData.selected_creature = selected_preview_creature

	GameData.player_team.clear()

	GameData.player_team.append(
		selected_preview_creature
	)

	GameData.player_index = 0
	GameData.battle_number = 0
	GameData.enemy_index = 0

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
			return "Dica: fogo é forte contra planta, mas sofre contra água."

		"água":
			return "Dica: água é forte contra fogo, mas sofre contra planta."

		"planta":
			return "Dica: planta é forte contra água, mas sofre contra fogo."

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


# Essas funções ficam aqui só para não dar erro nas conexões antigas da cena.
func _on_aquary_button_pressed():

	open_creature_popup("aquary")


func _on_flameling_button_pressed():

	open_creature_popup("flameling")


func _on_leafbat_button_pressed():

	open_creature_popup("leafbat")


func _on_back_button_pressed():

	close_popup()


func _on_confirm_button_pressed():

	confirm_starter()
