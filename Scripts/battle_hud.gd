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
@onready var switch_cooldown = $BottomPanel/MainBottomLayout/ActionButtons/SwitchButton/SwitchCooldown
@onready var run_button = $BottomPanel/MainBottomLayout/ActionButtons/RunButton

@onready var player_hp_bar = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerHPBar
@onready var player_name = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerName
@onready var player_hp_text = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerHPText
@onready var player_type = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/PlayerType

@onready var enemy_hp_bar = $EnemyInfo/EnemyLayout/EnemyHPBar
@onready var enemy_name = $EnemyInfo/EnemyLayout/EnemyName
@onready var enemy_sprite = $EnemyInfo/EnemyLayout/EnemySprite
@onready var enemy_hp_text = $EnemyInfo/EnemyLayout/EnemyHPText
@onready var enemy_type = $EnemyInfo/EnemyLayout/EnemyType

@onready var combat_log = $BottomPanel/MainBottomLayout/PlayerInfo/VBoxContainer/combatlog

var current_attacks = []
var player_ref

var displayed_player_hp = 0
var displayed_enemy_hp = 0

func setup(player, enemy):

	player_ref = player
	current_attacks = player.attacks
	
	displayed_player_hp = player.max_hp
	displayed_enemy_hp = enemy.max_hp

	
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
	
func add_log(text):
	combat_log.text += text + "\n"
	
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
	
	player_name.text = player.creature_name
	player_type.text = player.creature_type.capitalize()
	
	match player.creature_type:
		"água":
			player_type.modulate = Color("#4AA3FF")

		"fogo":
			player_type.modulate = Color("#FF5555")

		"planta":
			player_type.modulate = Color("#55CC55")

		_:
			player_type.modulate = Color.WHITE
	
	enemy_hp_bar.max_value = enemy.max_hp

	#if displayed_enemy_hp == 0:
	#	displayed_enemy_hp = enemy.hp

	displayed_enemy_hp = move_toward(
		displayed_enemy_hp,
		enemy.hp,
		50
	)

	#enemy_hp_bar.value = displayed_enemy_hp
	enemy_hp_bar.value = enemy.hp
	#print(enemy.hp)
	#print(enemy.max_hp)
	#print(enemy_hp_bar.value)
	#print(enemy_hp_bar.max_value)

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
	
	enemy_name.text = enemy.creature_name
	enemy_type.text = enemy.creature_type.capitalize()
	
	match enemy.creature_type:
		"água":
			enemy_type.modulate = Color("#4AA3FF")

		"fogo":
			enemy_type.modulate = Color("#FF5555")

		"planta":
			enemy_type.modulate = Color("#55CC55")

		_:
			enemy_type.modulate = Color.WHITE
	
	#enemy_sprite.texture = load(enemy.sprite_path)
	#enemy_sprite.scale.x = -1
	#enemy_sprite.scale = Vector2(-1, 1)
	

func update_cooldown_visual():

	update_single_cooldown(
		cooldown1,
		0
	)

	update_single_cooldown(
		cooldown2,
		1
	)

	update_single_cooldown(
		cooldown3,
		2
	)

func update_single_cooldown(cooldown_node, attack_index):

	if current_attacks.size() <= attack_index:
		cooldown_node.visible = false
		return

	var attack_data = current_attacks[attack_index]

	var cd = player_ref.attack_cooldowns[
		attack_data.name
	]

	if cd <= 0:
		cooldown_node.value = 0
		cooldown_node.visible = false
		return

	cooldown_node.visible = true
	cooldown_node.max_value = 360

	var max_cd = player_ref.global_attack_cooldown_max

	if max_cd <= 0:
		max_cd = attack_data.cooldown

	cooldown_node.value = 360 - (
		(cd / max_cd) * 360
	)
	
func update_switch_cooldown(current_cd, max_cd):

	if max_cd <= 0:
		switch_cooldown.value = 0
		return

	if current_cd <= 0:
		switch_cooldown.value = 0
		return

	switch_cooldown.value = 360 - ((current_cd / max_cd) * 360)
