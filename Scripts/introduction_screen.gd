extends Control

const UISkin = preload("res://Scripts/ui_skin.gd")

@onready var dialogue_label = $DialogueBox/Dialogue

var current_text = 0

var dialogues = [
	"Olá, treinador! Bem-vindo ao mundo das criaturas elementais.",
	"Essas criaturas vivem em harmonia com os humanos e adoram batalhas amistosas.",
	"Em uma batalha, duas criaturas utilizam ataques e habilidades para derrotar o adversário.",
	"Se deseja se tornar um Mestre das Criaturas, deverá vencer várias batalhas seguidas.",
	"Após cada vitória, você poderá recrutar uma criatura derrotada para sua equipe.",
	"Agora chegou a hora de escolher seu primeiro companheiro de aventura! Faça uma sábia escolha..."
]

func _ready():
	apply_ui_skin()
	dialogue_label.text = dialogues[0]

func _on_next_pressed() -> void:

	current_text += 1

	if current_text >= dialogues.size():

		get_tree().change_scene_to_file(
			"res://Scenes/StarterSelection.tscn"
		)

		return

	dialogue_label.text = dialogues[current_text]

func _process(_delta):

	if Input.is_action_just_pressed("ui_accept"):
		_on_next_pressed()

func apply_ui_skin():

	var dialogue_box = get_node_or_null("DialogueBox")

	if dialogue_box:
		UISkin.apply_panel_style(dialogue_box)

	dialogue_label.add_theme_font_override(
		"font",
		UISkin.FONT
	)

	dialogue_label.add_theme_font_size_override(
		"font_size",
		17
	)

	dialogue_label.add_theme_color_override(
		"font_color",
		Color("#3B2416")
	)

	dialogue_label.add_theme_color_override(
		"font_outline_color",
		Color("#F6D6A2")
	)

	dialogue_label.add_theme_constant_override(
		"outline_size",
		1
	)

	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var next_button = find_child(
		"Next",
		true,
		false
	)

	if next_button and next_button is Button:
		UISkin.apply_travel_button(next_button, 16)

	var next_button_2 = find_child(
		"NextButton",
		true,
		false
	)

	if next_button_2 and next_button_2 is Button:
		UISkin.apply_travel_button(next_button_2, 16)
