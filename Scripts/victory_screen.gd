extends Control

const UISkin = preload("res://Scripts/ui_skin.gd")
const CreatureDatabase = preload("res://Scripts/Data/creature_database.gd")
const TITLE_FONT = preload("res://Assets/Fonts/GrapeSoda.ttf")
const CONTENT_FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")

var restart_button: Button
var main_menu_button: Button
var quit_button: Button


func _ready():

	get_tree().paused = false

	fix_root_layout()
	hide_old_nodes()
	build_victory_screen()


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

	for child in get_children():
		child.visible = false


func build_victory_screen():

	var background = ColorRect.new()
	background.color = Color("#090B18")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	create_background_glow()
	create_stars()

	var title = create_label(
		"VITÓRIA!",
		Vector2(0, 35),
		Vector2(1280, 85),
		72,
		TITLE_FONT
	)
	title.add_theme_color_override("font_color", Color("#FFD84A"))
	title.add_theme_color_override("font_outline_color", Color("#3B1D00"))
	title.add_theme_constant_override("outline_size", 7)
	add_child(title)

	var subtitle = create_label(
		"Você se tornou um Mestre de Monstaria!",
		Vector2(0, 120),
		Vector2(1280, 45),
		28,
		CONTENT_FONT
	)
	subtitle.add_theme_color_override("font_color", Color.WHITE)
	add_child(subtitle)

	var main_panel = Panel.new()
	main_panel.anchor_left = 0.5
	main_panel.anchor_top = 0.5
	main_panel.anchor_right = 0.5
	main_panel.anchor_bottom = 0.5
	main_panel.offset_left = -500
	main_panel.offset_top = -170
	main_panel.offset_right = 500
	main_panel.offset_bottom = 145
	UISkin.apply_panel_style(main_panel)
	add_child(main_panel)

	var panel_title = create_label(
		"Jornada concluída",
		Vector2(0, 18),
		Vector2(1000, 35),
		24,
		CONTENT_FONT
	)
	panel_title.add_theme_color_override("font_color", Color("#FFD84A"))
	UISkin.apply_dark_label(panel_title, 24)
	main_panel.add_child(panel_title)

	var description = RichTextLabel.new()
	description.position = Vector2(80, 62)
	description.size = Vector2(840, 105)
	description.bbcode_enabled = true
	description.scroll_active = false
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_font_override("normal_font", CONTENT_FONT)
	description.add_theme_font_override("bold_font", CONTENT_FONT)
	description.add_theme_font_size_override("normal_font_size", 15)
	description.text = (
		"[center]" +
		"Você venceu as [b]5 batalhas[/b], recrutou novas criaturas e dominou as vantagens de tipo.\n\n" +
		"[color=#FFAA00][b]Agora você é oficialmente um Mestre de Monstaria![/b][/color]" +
		"[/center]"
	)
	UISkin.apply_travel_rich_text(description, 15)
	main_panel.add_child(description)

	var stats_box = HBoxContainer.new()
	stats_box.position = Vector2(135, 185)
	stats_box.size = Vector2(730, 80)
	stats_box.add_theme_constant_override("separation", 30)
	main_panel.add_child(stats_box)

	add_stat_card(stats_box, "Batalhas", "5")
	add_stat_card(stats_box, "Equipe", str(GameData.player_team.size()))
	add_stat_card(stats_box, "Título", "Mestre")

	var team_title = create_label(
		"Seu time final",
		Vector2(0, 470),
		Vector2(1280, 35),
		23,
		CONTENT_FONT
	)
	team_title.add_theme_color_override("font_color", Color("#FFD84A"))
	add_child(team_title)

	create_team_display()

	create_buttons()


func create_background_glow():

	var glow_1 = ColorRect.new()
	glow_1.color = Color(0.45, 0.18, 0.9, 0.16)
	glow_1.position = Vector2(-120, -100)
	glow_1.size = Vector2(520, 520)
	add_child(glow_1)

	var glow_2 = ColorRect.new()
	glow_2.color = Color(1.0, 0.65, 0.05, 0.13)
	glow_2.position = Vector2(880, 300)
	glow_2.size = Vector2(500, 500)
	add_child(glow_2)


func create_stars():

	var star_data = [
		[Vector2(105, 80), "✦", 28],
		[Vector2(1120, 80), "✦", 28],
		[Vector2(210, 210), "★", 20],
		[Vector2(1015, 205), "★", 20],
		[Vector2(90, 520), "✦", 22],
		[Vector2(1160, 510), "✦", 22],
		[Vector2(640, 30), "★", 18]
	]

	for data in star_data:

		var star = Label.new()
		star.text = data[1]
		star.position = data[0]
		star.size = Vector2(60, 60)
		star.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		star.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		star.add_theme_font_size_override("font_size", data[2])
		star.add_theme_color_override("font_color", Color("#FFD84A"))
		add_child(star)

		animate_star(star)


func animate_star(star):

	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(
		star,
		"modulate:a",
		0.25,
		0.8
	)

	tween.tween_property(
		star,
		"modulate:a",
		1.0,
		0.8
	)


func add_stat_card(parent, stat_name, stat_value):

	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(230, 80)
	parent.add_child(card)
	
	UISkin.apply_slot_style(card)

	var box = VBoxContainer.new()
	card.add_child(box)

	var value_label = Label.new()
	value_label.text = stat_value
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.add_theme_font_override("font", TITLE_FONT)
	value_label.add_theme_font_size_override("font_size", 34)
	value_label.add_theme_color_override("font_color", Color("#FFD84A"))
	box.add_child(value_label)

	var name_label = Label.new()
	name_label.text = stat_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.add_theme_font_override("font", CONTENT_FONT)
	name_label.add_theme_font_size_override("font_size", 15)
	box.add_child(name_label)


func create_team_display():

	var team_container = HBoxContainer.new()
	team_container.anchor_left = 0.5
	team_container.anchor_right = 0.5
	team_container.anchor_top = 0
	team_container.anchor_bottom = 0
	team_container.offset_left = -535
	team_container.offset_top = 510
	team_container.offset_right = 535
	team_container.offset_bottom = 655
	team_container.add_theme_constant_override("separation", 18)
	add_child(team_container)

	for creature_id in GameData.player_team:

		add_team_card(
			team_container,
			creature_id
		)


func add_team_card(parent, creature_id):

	if not CreatureDatabase.CREATURES.has(creature_id):
		return

	var creature = CreatureDatabase.CREATURES[creature_id]

	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(200, 140)
	parent.add_child(card)
	
	UISkin.apply_slot_style(card)

	var box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	card.add_child(box)

	var sprite = TextureRect.new()
	sprite.texture = load(creature["sprite"])
	sprite.custom_minimum_size = Vector2(180, 78)
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	box.add_child(sprite)

	var name_label = Label.new()
	name_label.text = creature["name"]
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_override("font", CONTENT_FONT)
	name_label.add_theme_font_size_override("font_size", 13)
	box.add_child(name_label)

	var type_label = Label.new()
	type_label.text = creature["type"].capitalize()
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.modulate = get_type_color(creature["type"])
	type_label.add_theme_font_override("font", CONTENT_FONT)
	type_label.add_theme_font_size_override("font_size", 12)
	box.add_child(type_label)

func create_buttons():

	var button_box = HBoxContainer.new()
	button_box.anchor_left = 0.5
	button_box.anchor_right = 0.5
	button_box.anchor_top = 1
	button_box.anchor_bottom = 1
	button_box.offset_left = -445
	button_box.offset_top = -75
	button_box.offset_right = 445
	button_box.offset_bottom = -25
	button_box.add_theme_constant_override("separation", 35)
	add_child(button_box)

	restart_button = create_button("Jogar novamente")
	main_menu_button = create_button("Menu inicial")
	quit_button = create_button("Sair do jogo")

	button_box.add_child(restart_button)
	button_box.add_child(main_menu_button)
	button_box.add_child(quit_button)

	restart_button.pressed.connect(restart_game)
	main_menu_button.pressed.connect(go_to_main_menu)
	quit_button.pressed.connect(quit_game)


func create_button(button_text):

	var button = Button.new()
	button.text = button_text
	button.custom_minimum_size = Vector2(270, 50)
	UISkin.apply_travel_button(button, 16)
	button.add_theme_font_override("font", CONTENT_FONT)
	button.add_theme_font_size_override("font_size", 18)

	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color("#1A2541")
	normal_style.border_width_left = 2
	normal_style.border_width_top = 2
	normal_style.border_width_right = 2
	normal_style.border_width_bottom = 2
	normal_style.border_color = Color("#FFD84A")
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8

	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color("#2B3D68")
	hover_style.border_width_left = 2
	hover_style.border_width_top = 2
	hover_style.border_width_right = 2
	hover_style.border_width_bottom = 2
	hover_style.border_color = Color("#FFD84A")
	hover_style.corner_radius_top_left = 8
	hover_style.corner_radius_top_right = 8
	hover_style.corner_radius_bottom_left = 8
	hover_style.corner_radius_bottom_right = 8

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", hover_style)
	button.add_theme_color_override("font_color", Color.WHITE)

	UISkin.apply_travel_button(button, 16)
	return button


func create_label(text_value, label_position, label_size, font_size, font_file):

	var label = Label.new()

	label.text = text_value
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", font_file)
	label.add_theme_font_size_override("font_size", font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	return label


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


func restart_game():

	reset_game_data()

	get_tree().change_scene_to_file(
		"res://Scenes/StarterSelection.tscn"
	)


func go_to_main_menu():

	reset_game_data()

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu.tscn"
	)


func reset_game_data():

	GameData.player_team.clear()
	GameData.enemy_team.clear()
	GameData.recruit_options.clear()

	GameData.selected_creature = ""

	GameData.battle_number = 0
	GameData.player_index = 0
	GameData.enemy_index = 0

	GameData.demo_finished = false
	GameData.became_master = false
	GameData.result_victory = false

	GameData.first_battle_tip_shown = false
	GameData.elemental_tip_shown = false

	GameData.current_enemy_dialogue = []
	GameData.current_enemy_sprite = ""


func quit_game():

	get_tree().quit()
