extends Control

signal attack_selected

@onready var attack1 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack1
@onready var attack2 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack2
@onready var attack3 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack3

@onready var player_hp_bar = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerHPBar
@onready var enemy_hp_bar = $EnemyInfo/EnemyLayout/EnemyHPBar
@onready var enemy_name = $EnemyInfo/EnemyLayout/EnemyName
@onready var enemy_sprite = $EnemyInfo/EnemyLayout/EnemySprite

var current_attacks = []
var player_ref

func setup(player):

	player_ref = player
	current_attacks = player.attacks
	
	if current_attacks.size() > 0:
		attack1.text = "Q - " + current_attacks[0].name
		
	if current_attacks.size() > 1:
		attack2.text = "W - " + current_attacks[1].name
		
	if current_attacks.size() > 2:
		attack3.text = "E - " + current_attacks[2].name

func _process(delta):

	if current_attacks.size() <= 0:
		return

	if current_attacks.size() > 0:
		update_attack_button(
			attack1,
			current_attacks[0]
		)
	
	if current_attacks.size() > 1:
		update_attack_button(
			attack2,
			current_attacks[1]
		)
	
	if current_attacks.size() > 2:
		update_attack_button(
			attack3,
			current_attacks[2]
		)
	
func update_attack_button(button, attack_data):

	var cooldown = player_ref.attack_cooldowns[attack_data.name]

	
	if cooldown > 0:
		
		var key_name = ""

		if button == attack1:
			key_name = "Q"

		elif button == attack2:
			key_name = "W"

		elif button == attack3:
			key_name = "E"

		button.text = (
			key_name +
			" - " +
			attack_data.name +
			" (" +
			str(snapped(cooldown, 0.1)) +
			"s)"
		)
		
		button.disabled = true
		
	else:
		
		var key_name = ""

		if button == attack1:
			key_name = "Q"

		elif button == attack2:
			key_name = "W"

		elif button == attack3:
			key_name = "E"

		button.text = key_name + " - " + attack_data.name
		
		button.disabled = false
		
func _ready():
	
	attack1.pressed.connect(func():
		attack_selected.emit(0)
	)
	
	attack2.pressed.connect(func():
		attack_selected.emit(1)
	)
	
	attack3.pressed.connect(func():
		attack_selected.emit(2)
	)

func update_battle_info(player, enemy):
	
	player_hp_bar.max_value = player.max_hp
	player_hp_bar.value = player.hp

	enemy_hp_bar.max_value = enemy.max_hp
	enemy_hp_bar.value = enemy.hp

	enemy_name.text = enemy.creature_name

	enemy_sprite.texture = load(enemy.sprite_path)
