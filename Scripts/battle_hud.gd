extends Control

const CONTENT_FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")
const UISkin = preload("res://Scripts/ui_skin.gd")

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
var enemy_ref

var battle_progress_label: Label
var attack_info_panel: Panel
var attack_info_text: RichTextLabel

var displayed_player_hp = 0
var displayed_enemy_hp = 0

func setup(player, enemy):

	player_ref = player
	current_attacks = player.attacks
	
	enemy_ref = enemy

	update_battle_progress_label()
	
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
	

	var is_in_cooldown = (
		player_ref.attack_cooldowns[
			attack_data.name
		] > 0
	)

	var is_global_locked = (
		player_ref.global_click_cooldown > 0
	)

	button.disabled = (
		is_in_cooldown or
		is_global_locked
	)

	if is_in_cooldown:

		button.modulate = Color(0.374, 0.374, 0.374, 1.0)

	elif is_global_locked:

		button.modulate = Color(0.374, 0.374, 0.374, 1.0)

	else:

		button.modulate = Color.WHITE
		
	if player_ref.is_paralyzed:

		text_label.text = "⚡ " + key_name + " - " + attack_data.name
		button.disabled = true
		button.modulate = Color(0.52, 0.51, 0.084, 1.0)
		return


	if attack_data.name == player_ref.frozen_attack:

		text_label.text = "❄ " + key_name + " - " + attack_data.name
		button.disabled = true
		button.modulate = Color(0.135, 0.671, 0.828, 1.0)
		return


	text_label.text = key_name + " - " + attack_data.name

	button.disabled = (
				player_ref.attack_cooldowns[
					attack_data.name
				] > 0
			)
	
func _ready():

	process_mode = Node.PROCESS_MODE_ALWAYS
	apply_hud_skin()
	fix_attack_buttons_layout()
	
	
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
	
	build_battle_progress_label()
	build_attack_info_panel()
	connect_attack_hover_events()
	
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
	
	match enemy.creature_type:
		"água":
			enemy_type.modulate = Color("#4AA3FF")

		"fogo":
			enemy_type.modulate = Color("#FF5555")

		"planta":
			enemy_type.modulate = Color("#55CC55")

		"normal":
			enemy_type.modulate = Color("#DDDDDD")

		"elemental":
			enemy_type.modulate = Color("#B35CFF")

		_:
			enemy_type.modulate = Color.WHITE
	
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
	
	match player.creature_type:
		"água":
			player_type.modulate = Color("#4AA3FF")

		"fogo":
			player_type.modulate = Color("#FF5555")

		"planta":
			player_type.modulate = Color("#55CC55")

		"normal":
			player_type.modulate = Color("#DDDDDD")

		"elemental":
			player_type.modulate = Color("#B35CFF")

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

	cooldown_node.value = 360 - (
	(cd / attack_data.cooldown) * 360
)
	
func update_switch_cooldown(current_cd, max_cd):

	if max_cd <= 0:
		switch_cooldown.value = 0
		return

	if current_cd <= 0:
		switch_cooldown.value = 0
		return

	switch_cooldown.value = 360 - ((current_cd / max_cd) * 360)

func build_battle_progress_label():

	if battle_progress_label != null:
		return

	battle_progress_label = Label.new()
	battle_progress_label.position = Vector2(25, 20)
	battle_progress_label.size = Vector2(360, 65)
	battle_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	battle_progress_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	battle_progress_label.add_theme_font_override("font", CONTENT_FONT)
	battle_progress_label.add_theme_font_size_override("font_size", 18)
	battle_progress_label.add_theme_color_override("font_color", Color.WHITE)
	battle_progress_label.add_theme_color_override("font_outline_color", Color.BLACK)
	battle_progress_label.add_theme_constant_override("outline_size", 4)
	UISkin.apply_light_label(battle_progress_label, 17)
	battle_progress_label.z_index = 150

	add_child(battle_progress_label)

	update_battle_progress_label()


func update_battle_progress_label():

	if battle_progress_label == null:
		return

	var current_battle = GameData.battle_number + 1
	var total_battles = GameData.total_battles
	var remaining_after_this = max(total_battles - current_battle, 0)

	battle_progress_label.text = (
		"BATALHA " +
		str(current_battle) +
		" / " +
		str(total_battles) +
		"\nFaltam " +
		str(remaining_after_this) +
		" depois desta"
	)
	
func build_attack_info_panel():

	if attack_info_panel != null:
		return

	attack_info_panel = Panel.new()
	attack_info_panel.visible = false
	attack_info_panel.size = Vector2(430, 255)
	attack_info_panel.z_index = 300
	attack_info_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	attack_info_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	UISkin.apply_panel_style(attack_info_panel)
	add_child(attack_info_panel)

	attack_info_text = RichTextLabel.new()
	attack_info_text.position = Vector2(18, 14)
	attack_info_text.size = Vector2(394, 225)
	attack_info_text.bbcode_enabled = true
	attack_info_text.scroll_active = false
	attack_info_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	attack_info_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	attack_info_text.process_mode = Node.PROCESS_MODE_ALWAYS
	attack_info_text.add_theme_font_override("normal_font", CONTENT_FONT)
	attack_info_text.add_theme_font_override("bold_font", CONTENT_FONT)
	attack_info_text.add_theme_font_size_override("normal_font_size", 14)
	UISkin.apply_travel_rich_text(attack_info_text, 14)
	attack_info_panel.add_child(attack_info_text)

func connect_attack_hover_events():

	attack1.mouse_entered.connect(
		show_attack_info.bind(0)
	)

	attack2.mouse_entered.connect(
		show_attack_info.bind(1)
	)

	attack3.mouse_entered.connect(
		show_attack_info.bind(2)
	)

	attack1.mouse_exited.connect(hide_attack_info)
	attack2.mouse_exited.connect(hide_attack_info)
	attack3.mouse_exited.connect(hide_attack_info)


func show_attack_info(attack_index):

	if attack_info_panel == null:
		return

	if current_attacks.size() <= attack_index:
		return

	var attack_data = current_attacks[attack_index]

	attack_info_text.text = build_attack_info_text(
		attack_data
	)

	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	var panel_pos = mouse_pos + Vector2(20, -260)

	panel_pos.x = clamp(
		panel_pos.x,
		20,
		viewport_size.x - 450
	)

	panel_pos.y = clamp(
		panel_pos.y,
		20,
		viewport_size.y - 280
	)

	attack_info_panel.global_position = panel_pos
	attack_info_panel.visible = true


func hide_attack_info():

	if attack_info_panel:
		attack_info_panel.visible = false


func build_attack_info_text(attack_data):

	var effectiveness_text = "Normal"

	if player_ref != null and enemy_ref != null:

		var multiplier = player_ref.get_type_multiplier(
			enemy_ref,
			attack_data.type
		)

		if multiplier > 1:
			effectiveness_text = "[color=#55FF55]Super efetivo contra o inimigo atual[/color]"

		elif multiplier < 1:
			effectiveness_text = "[color=#FF5555]Fraco contra o inimigo atual[/color]"

		else:
			effectiveness_text = "[color=white]Dano normal contra o inimigo atual[/color]"

	return (
		"[b][color=#FFD84A]" +
		attack_data.name +
		"[/color][/b]\n\n" +

		"[b]Tipo:[/b] " +
		get_colored_type_name(attack_data.type) +
		"\n" +

		"[b]Dano:[/b] " +
		str(attack_data.damage) +
		"\n" +

		"[b]Cooldown:[/b] " +
		str(attack_data.cooldown) +
		"s\n" +

		"[b]Efeito:[/b] " +
		get_effect_text(attack_data.effect) +
		"\n\n" +

		"[b]Nesta batalha:[/b]\n" +
		effectiveness_text +
		"\n\n" +

		"[b][color=#FFAA00]COMBOS:[/color][/b]\n" +
		get_attack_combo_text(attack_data)
	)


func get_colored_type_name(type_name):

	match type_name:

		"fogo":
			return "[color=#FF5555]Fogo[/color]"

		"água":
			return "[color=#4AA3FF]Água[/color]"

		"planta":
			return "[color=#55CC55]Planta[/color]"

		"normal":
			return "[color=#DDDDDD]Normal[/color]"

		"elemental":
			return "[color=#B35CFF]Elemental[/color]"

		_:
			return type_name.capitalize()


func get_effect_text(effect_name):

	match effect_name:

		"burn":
			return "[color=#FF8844]Queimadura[/color]"

		"freeze":
			return "[color=#66DDFF]Congelamento[/color]"

		"paralyze":
			return "[color=#FFFF66]Paralisia[/color]"

		_:
			return "Nenhum"


func get_attack_combo_text(attack_data):

	var combo_text = ""

	match attack_data.effect:

		"burn":
			combo_text += "• Aplica queimadura. Depois, ataques de [color=#55CC55]planta[/color] causam dano extra.\n"

		"freeze":
			combo_text += "• Congela um ataque do alvo. Depois, ataques de [color=#FF5555]fogo[/color] causam dano extra.\n"

		"paralyze":
			combo_text += "• Paralisa o alvo. Depois, ataques [color=#DDDDDD]normais[/color] causam dano extra.\n"

	match attack_data.type:

		"fogo":
			combo_text += "• Causa combo em inimigos congelados.\n"

		"planta":
			combo_text += "• Causa combo em inimigos queimando.\n"

		"normal":
			combo_text += "• Causa combo em inimigos paralisados.\n"

		"água":
			combo_text += "• Pode preparar congelamento para um ataque de fogo depois.\n"

		"elemental":
			combo_text += "• É ótimo para pressionar fogo, água e planta.\n"

	if combo_text == "":
		combo_text = "• Sem combo direto, mas pode ser usado para pressão e controle de cooldown."

	return combo_text.strip_edges()

func apply_hud_skin():

	#var bottom_panel = get_node_or_null("BottomPanel")

	#if bottom_panel:
		#UISkin.apply_panel_style(bottom_panel)

	#var enemy_info_panel = get_node_or_null("EnemyInfo")

	#if enemy_info_panel:
		#UISkin.apply_panel_style(enemy_info_panel)

	var attack_buttons = [
		attack1,
		attack2,
		attack3
	]

	for button in attack_buttons:

		if button:
			UISkin.apply_slot_button(button, 13)

	var action_buttons = [
		switch_button,
		run_button
	]

	for button in action_buttons:

		if button:
			UISkin.apply_slot_button(button, 13)

	var labels = [
		attack1_text,
		attack2_text,
		attack3_text,
		player_name,
		player_hp_text,
		player_type,
		enemy_name,
		enemy_hp_text,
		enemy_type
	]

	for label in labels:

		if label:
			UISkin.apply_dark_label(label, 13)

	if combat_log:
		UISkin.apply_travel_rich_text(combat_log, 12)

	UISkin.apply_hp_bar(player_hp_bar)
	UISkin.apply_hp_bar(enemy_hp_bar)

func fix_attack_buttons_layout():

	var attack_buttons = [
		attack1,
		attack2,
		attack3
	]

	var attack_texts = [
		attack1_text,
		attack2_text,
		attack3_text
	]

	for button in attack_buttons:

		if button == null:
			continue

		button.custom_minimum_size = Vector2(205, 72)
		button.size = Vector2(205, 72)

		UISkin.apply_slot_button(button, 13)

	for text_label in attack_texts:

		if text_label == null:
			continue

		text_label.set_anchors_preset(Control.PRESET_FULL_RECT)

		text_label.offset_left = 0
		text_label.offset_top = 0
		text_label.offset_right = 0
		text_label.offset_bottom = 0

		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

		UISkin.apply_light_label(text_label, 13)

		# COR DO TEXTO DOS BOTÕES DE ATAQUE
		text_label.add_theme_color_override(
			"font_color",
			Color("#F6D6A2")
		)

		# COR DO CONTORNO DO TEXTO
		text_label.add_theme_color_override(
			"font_outline_color",
			Color("#3B2416")
		)

		text_label.add_theme_constant_override(
			"outline_size",
			2
		)
