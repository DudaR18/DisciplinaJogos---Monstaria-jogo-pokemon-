extends Control

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
