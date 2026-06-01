extends Control

signal attack_selected
signal switch_pressed
signal run_pressed

@onready var attack1 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack1
@onready var attack2 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack2
@onready var attack3 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack3

@onready var cooldown1 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack1/Cooldown1
@onready var cooldown2 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack2/Cooldown2
@onready var cooldown3 = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack3/Cooldown3

@onready var attack1_text = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack1/AttackText
@onready var attack2_text = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack2/AttackText
@onready var attack3_text = $BottomPanel/MainBottomLayout/AttackPanel/AttackGrid/Attack3/AttackText

@onready var switch_button = $BottomPanel/MainBottomLayout/ActionButtons/SwitchButton
@onready var run_button = $BottomPanel/MainBottomLayout/ActionButtons/RunButton

@onready var player_hp_bar = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerHPBar
@onready var player_name = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerName
@onready var player_hp_text = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerHPText

@onready var enemy_hp_bar = $EnemyInfo/EnemyLayout/EnemyHPBar
@onready var enemy_name = $EnemyInfo/EnemyLayout/EnemyName
@onready var enemy_sprite = $EnemyInfo/EnemyLayout/EnemySprite
@onready var enemy_hp_text = $EnemyInfo/EnemyLayout/EnemyHPText

@onready var combat_log = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/combatlog

var current_attacks = []
var player_ref

var displayed_player_hp = 0
var displayed_enemy_hp = 0

func setup(player):

	player_ref = player
	current_attacks = player.attacks
	
	displayed_player_hp = player.max_hp
	
	if current_attacks.size() > 0:
		attack1_text.text = "Q - " + current_attacks[0].name
		
	if current_attacks.size() > 1:
		attack2_text.text = "W - " + current_attacks[1].name
		
	if current_attacks.size() > 2:
		attack3_text.text = "E - " + current_attacks[2].name

func _process(_delta):

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
	
	update_cooldown_visual()
	
func update_attack_button(button, attack_data):
	
	var text_label
	var key_name

	if button == attack1:
		text_label = attack1_text
		key_name = "Q"

	elif button == attack2:
		text_label = attack2_text
		key_name = "W"

	else:
		text_label = attack3_text
		key_name = "E"
		
	if player_ref.is_paralyzed:

		text_label.text = "⚡ " + key_name + " - " + attack_data.name

		button.disabled = true
		return


	if attack_data.name == player_ref.frozen_attack:

		text_label.text = "❄ " + key_name + " - " + attack_data.name

		button.disabled = true
		return


	text_label.text = key_name + " - " + attack_data.name

	button.disabled = (
				player_ref.attack_cooldowns[
					attack_data.name
				] > 0
			)
	
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

	switch_button.pressed.connect(func():
		switch_pressed.emit()
	)

	run_button.pressed.connect(func():
		run_pressed.emit()
	)

func update_battle_info(player, enemy):
	
	player_hp_bar.max_value = player.max_hp
	
	displayed_player_hp = move_toward(
		displayed_player_hp,
		player.hp,
		50
	)

	player_hp_bar.value = displayed_player_hp
	
	var percent = float(player.hp) / player.max_hp
	if percent > 0.5:
		player_hp_bar.tint_progress = Color.GREEN

	elif percent > 0.25:
		player_hp_bar.tint_progress = Color.YELLOW

	else:
		player_hp_bar.tint_progress = Color.RED
	
	player_hp_text.text = (
		str(player.hp) +
		"/" +
		str(player.max_hp)
	)
	
	player_name.text = (
		player.creature_name +
		" - " +
		player.creature_type.capitalize()
	)
	
	enemy_hp_bar.max_value = enemy.max_hp
	
	displayed_enemy_hp = move_toward(
		displayed_enemy_hp,
		enemy.hp,
		50
	)

	enemy_hp_bar.value = displayed_enemy_hp
	
	var percent2 = float(enemy.hp) / enemy.max_hp
	if percent2 > 0.5:
		enemy_hp_bar.tint_progress = Color.GREEN

	elif percent2 > 0.25:
		enemy_hp_bar.tint_progress = Color.YELLOW

	else:
		enemy_hp_bar.tint_progress = Color.RED
		
	enemy_hp_text.text = (
		str(enemy.hp) +
		"/" +
		str(enemy.max_hp)
	)
	
	enemy_name.text = (
		enemy.creature_name +
		" - " +
		enemy.creature_type.capitalize()
	)
	
	#enemy_sprite.texture = load(enemy.sprite_path)
	#enemy_sprite.scale.x = -1
	#enemy_sprite.scale = Vector2(-1, 1)
	
func add_log(text):
	combat_log.text += text + "\n"

func update_cooldown_visual():

	if current_attacks.size() > 0:

		var cd = player_ref.attack_cooldowns[
			current_attacks[0].name
		]

		cooldown1.max_value = 360

		cooldown1.value = 360 - (
			(cd / current_attacks[0].cooldown) * 360
		)

		cooldown1.visible = true


	if current_attacks.size() > 1:
		var cd = player_ref.attack_cooldowns[
			current_attacks[1].name
		]

		cooldown2.max_value = 360
		cooldown2.value = 360 - (
			(cd / current_attacks[1].cooldown) * 360
		)
		
		cooldown2.visible = true


	if current_attacks.size() > 2:

		var cd = player_ref.attack_cooldowns[
			current_attacks[2].name
		]

		cooldown3.max_value = 360
		cooldown3.value = 360 - (
			(cd / current_attacks[2].cooldown) * 360
		)
		cooldown3.visible = true
