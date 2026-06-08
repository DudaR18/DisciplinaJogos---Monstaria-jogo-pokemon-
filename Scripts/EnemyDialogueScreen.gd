extends Control

@onready var dialogue_label = $DialogueBox/Dialogue
@onready var enemy_sprite = $EnemySprite

var current_text = 0
var dialogues = []

func _ready():

	dialogues = GameData.current_enemy_dialogue

	enemy_sprite.texture = load(
		GameData.current_enemy_sprite
	)

	dialogue_label.text = dialogues[0]
	
func _on_next_pressed():

	current_text += 1

	if current_text >= dialogues.size():

		get_tree().change_scene_to_file(
			"res://Scenes/Battle.tscn"
		)

		return

	dialogue_label.text = dialogues[current_text]
