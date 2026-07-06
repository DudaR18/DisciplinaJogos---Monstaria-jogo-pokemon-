extends Control

signal creature_selected(creature_id)

const CreatureDatabase = preload("res://Scripts/Data/creature_database.gd")
const MAIN_FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")
const UISkin = preload("res://Scripts/ui_skin.gd")

@onready var title = $CenterContainer/Panel/VBoxContainer/Title
@onready var vbox = $CenterContainer/Panel/VBoxContainer
@onready var close_button = $CenterContainer/Panel/VBoxContainer/CloseButton

var forced_mode = false
var current_creature_id = ""
var creature_hp = {}


func _ready():

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	UISkin.apply_panel_style($CenterContainer/Panel)
	UISkin.apply_label_style(title, 18)
	UISkin.apply_close_button_slot_style(close_button)

	hide_old_buttons()
	setup_title()
	setup_buttons()
	setup_close_button()


func setup_title():

	if forced_mode:
		title.text = "Escolha sua próxima criatura"
	else:
		title.text = "Trocar criatura"


func hide_old_buttons():

	var old_button_names = [
		"CreatureButton1",
		"CreatureButton2",
		"CreatureButton3"
	]

	for button_name in old_button_names:

		var button = vbox.get_node_or_null(button_name)

		if button:
			button.visible = false
			button.disabled = true


func setup_buttons():

	for creature_id in GameData.player_team:

		add_creature_option(
			creature_id
		)


func add_creature_option(creature_id):

	if not CreatureDatabase.CREATURES.has(creature_id):
		return

	var creature = CreatureDatabase.CREATURES[creature_id]

	var hp_value = get_creature_hp(
		creature_id,
		creature["max_hp"]
	)

	var is_current = creature_id == current_creature_id
	var is_dead = hp_value <= 0

	var row = PanelContainer.new()
	row.custom_minimum_size = Vector2(430, 86)
	
	UISkin.apply_slot_style(row, false, is_dead)

	vbox.add_child(row)

	vbox.move_child(
		row,
		close_button.get_index()
	)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	row.add_child(hbox)

	var sprite = TextureRect.new()
	sprite.texture = load(creature["sprite"])
	sprite.custom_minimum_size = Vector2(70, 70)
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hbox.add_child(sprite)

	var info_box = VBoxContainer.new()
	info_box.custom_minimum_size = Vector2(210, 70)
	info_box.add_theme_constant_override("separation", 2)
	hbox.add_child(info_box)

	var name_label = Label.new()
	name_label.text = creature["name"]
	name_label.add_theme_font_override("font", MAIN_FONT)
	name_label.add_theme_font_size_override("font_size", 18)
	info_box.add_child(name_label)

	var type_label = Label.new()
	type_label.text = "Tipo: " + creature["type"].capitalize()
	type_label.modulate = get_type_color(creature["type"])
	type_label.add_theme_font_override("font", MAIN_FONT)
	type_label.add_theme_font_size_override("font_size", 14)
	info_box.add_child(type_label)

	var hp_label = Label.new()
	hp_label.text = "HP: " + str(hp_value) + " / " + str(creature["max_hp"])
	hp_label.add_theme_font_override("font", MAIN_FONT)
	hp_label.add_theme_font_size_override("font_size", 13)
	info_box.add_child(hp_label)

	var action_button = Button.new()
	action_button.custom_minimum_size = Vector2(125, 50)
	action_button.add_theme_font_override("font", MAIN_FONT)
	action_button.add_theme_font_size_override("font_size", 14)
	UISkin.apply_button_style(action_button)
	hbox.add_child(action_button)

	if is_current:

		action_button.text = "Em campo"
		action_button.disabled = true

	elif is_dead:

		action_button.text = "Derrotado"
		action_button.disabled = true

		row.modulate = Color(0.55, 0.55, 0.55, 1.0)

	else:

		if forced_mode:
			action_button.text = "Escolher"
		else:
			action_button.text = "Trocar"

		action_button.pressed.connect(func():

			select_creature(creature_id)
		)


func get_creature_hp(creature_id, max_hp):

	if creature_hp.has(creature_id):
		return creature_hp[creature_id]

	return max_hp


func setup_close_button():

	if forced_mode:

		close_button.visible = false
		close_button.disabled = true

	else:

		close_button.visible = true
		close_button.disabled = false

		if not close_button.pressed.is_connected(close_menu):
			close_button.pressed.connect(close_menu)


func select_creature(creature_id):

	creature_selected.emit(creature_id)

	queue_free()


func close_menu():

	if forced_mode:
		return

	queue_free()


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


func _on_close_button_pressed() -> void:

	close_menu()
