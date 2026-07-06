extends Node2D

const UISkin = preload("res://Scripts/ui_skin.gd")

@onready var player = $PlayerCreature
@onready var enemy = $EnemyCreature
@onready var hud = $CanvasLayer/BattleHud


var switch_menu_open = false
var switch_cooldown = 0.0
var max_switch_cooldown = 5.0
var forced_switch_open = false
var is_switching_creature = false
var run_confirm_open = false
var player_team_hp = {}

var manual_pause_active = false
var manual_pause_layer: CanvasLayer
var manual_pause_indicator: Label

func _ready():
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	create_manual_pause_screen()
	
	GameData.player_index = 0

	player.creature_id = GameData.player_team[
		GameData.player_index
	]

	player.load_creature_data()

	setup_player_team_hp()

	GameData.generate_enemy_team(
		player.creature_type
	)

	GameData.enemy_index = 0

	enemy.creature_id = GameData.enemy_team[0]
	enemy.load_creature_data()
	apply_enemy_balance()

	player.died.connect(on_player_died)
	enemy.died.connect(on_enemy_died)

	hud.setup(player, enemy)

	hud.attack_selected.connect(on_attack_selected)
	hud.switch_pressed.connect(on_switch_pressed)
	hud.run_pressed.connect(on_run_pressed)

	await player.play_summon_animation()
	await enemy.play_summon_animation()

	if GameData.battle_number == 0 and not GameData.first_battle_tip_shown:

		GameData.first_battle_tip_shown = true

		show_battle_tip_popup(
			"first_battle"
		)

	elif GameData.battle_number == 2 and not GameData.elemental_tip_shown:

		GameData.elemental_tip_shown = true

		show_battle_tip_popup(
			"elemental"
		)
		
	enemy_ai()
	
func show_battle_tip_popup(tip_mode = "first_battle"):

	var tip_scene = preload(
		"res://Scenes/BattleTipPopup.tscn"
	)

	var tip_popup = tip_scene.instantiate()

	tip_popup.tip_mode = tip_mode

	$CanvasLayer.add_child(tip_popup)
	
func on_player_died():

	player_team_hp[player.creature_id] = 0

	hud.add_log(
		player.creature_name +
		" não pode mais batalhar!"
	)

	# Na primeira batalha o jogador só tem uma criatura.
	# Se ela cair, é derrota direta.
	if GameData.battle_number == 0:

		show_result_screen(false)

		return

	if not has_alive_player_reserve():

		show_result_screen(false)

		return

	open_forced_switch_menu()
	
func has_alive_player_reserve():

	for creature_id in GameData.player_team:

		if creature_id == player.creature_id:
			continue

		if player_team_hp.has(creature_id) and player_team_hp[creature_id] > 0:
			return true

	return false
	
func open_forced_switch_menu():

	if forced_switch_open:
		return

	forced_switch_open = true
	switch_menu_open = true

	set_pause_safe(true)

	var switch_scene = preload(
		"res://Scenes/SwitchMenu.tscn"
	)

	var switch_menu = switch_scene.instantiate()

	switch_menu.forced_mode = true
	switch_menu.current_creature_id = player.creature_id
	switch_menu.creature_hp = player_team_hp.duplicate()

	$CanvasLayer.add_child(switch_menu)

	switch_menu.creature_selected.connect(func(creature_id):

		set_pause_safe(false)

		forced_switch_open = false
		switch_menu_open = false

		if not is_inside_tree():
			return

		await switch_player_creature(
			creature_id,
			true
		)

		if not is_inside_tree():
			return

		enemy_ai()
		)

	
func on_enemy_died():

	print("========")
	print("ENEMY DIED")
	print("INDEX:", GameData.enemy_index)
	print("TEAM:", GameData.enemy_team)
	print("========")

	if GameData.enemy_index < GameData.enemy_team.size() - 1:

		await spawn_next_enemy()

	else:

		if GameData.battle_number >= GameData.total_battles - 1:

			GameData.became_master = true

			get_tree().change_scene_to_file(
				"res://Scenes/VictoryScreen.tscn"
			)

			return

		GameData.recruit_options = GameData.get_recruit_options(2)

		get_tree().change_scene_to_file(
			"res://Scenes/RecruitScreen.tscn"
		)
	
func _process(_delta):
	
	if get_tree().paused:
		return
		
#	if Input.is_action_just_pressed("ui_select"):
#		enemy.attack(player)
		
	#if Input.is_action_just_pressed("ui_accept"):
		#player.attack(enemy, player.attacks[0])
	
	if switch_cooldown > 0:
		switch_cooldown -= _delta

		if switch_cooldown < 0:
			switch_cooldown = 0
	
	hud.update_switch_cooldown(
		switch_cooldown,
		max_switch_cooldown
	)

	if Input.is_action_just_pressed("q"):
		await on_attack_selected(0)

	if Input.is_action_just_pressed("w"):
		await on_attack_selected(1)

	if Input.is_action_just_pressed("e"):
		await on_attack_selected(2)
	
	hud.update_battle_info(player, enemy)
	
	if Input.is_action_just_pressed("switch creature"):
		on_switch_pressed()

	if Input.is_action_just_pressed("run battle"):
		on_run_pressed()
	
func enemy_ai():

	while enemy.hp > 0 and player.hp > 0:

		await get_tree().create_timer(2.0).timeout
		
		if get_tree().paused:
			continue
		
		var random_attack = enemy.attacks.pick_random()


		var success = await enemy.attack(
			player,
			random_attack
		)


		if success:
			
			var damage = enemy.calculate_damage(
				player,
				random_attack.damage,
				random_attack.type
			)
			
			
			var multiplier = enemy.get_type_multiplier(
				player,
				random_attack.type
			)
			
			if multiplier > 1:
				player.show_floating_text(
					"SUPER EFETIVO!",
					Color.DARK_GREEN
			)

			elif multiplier < 1:
				player.show_floating_text(
					"FRACO!",
					Color.RED
			)
			
			var effectiveness_text = ""
			
			
			if multiplier > 1:
				effectiveness_text = " É super efetivo!"
				
			elif multiplier < 1:
				effectiveness_text = " Não foi muito efetivo..."
			

			hud.add_log(
				enemy.creature_name +
				" usou " +
				random_attack.name +
				" e causou " +
				str(damage) +
				" de dano!" +
				effectiveness_text
			)
			
			if enemy.last_combo_text != "":
				hud.add_log(
					enemy.last_combo_text
				)
	
func on_attack_selected(index) -> void:

	if index >= player.attacks.size():
		return
		
	var attack_data = player.attacks[index]

	
	var success = await player.attack(
		enemy,
		attack_data
	)
	
	
	if success:
		
		var damage = player.calculate_damage(
			enemy,
			attack_data.damage,
			attack_data.type
		)

		var multiplier = player.get_type_multiplier(
			enemy,
			attack_data.type
		)
		
		if multiplier > 1:
			enemy.show_floating_text(
				"SUPER EFETIVO!"
			)

		elif multiplier < 1:
			enemy.show_floating_text(
				"FRACO!"
			)
		var effectiveness_text = ""

		if multiplier > 1:
			effectiveness_text = " É super efetivo!"

		elif multiplier < 1:
			effectiveness_text = " Não foi muito efetivo..."
		
		hud.add_log(
			player.creature_name +
			" usou " +
			attack_data.name +
			" e causou " +
			str(damage) +
			" de dano!" +
			effectiveness_text
		)
		
		if player.last_combo_text != "":
			hud.add_log(
				player.last_combo_text
			)
	
func show_status_log(attacker, target, attack_data):

	match attack_data.effect:

		"burn":
			hud.add_log(
				attacker.creature_name +
				" usou " +
				attack_data.name +
				"! " +
				target.creature_name +
				" está queimando!"
			)

		"freeze":
			hud.add_log(
				attacker.creature_name +
				" usou " +
				attack_data.name +
				"! Um ataque de " +
				target.creature_name +
				" foi congelado!"
			)

		"paralyze":
			hud.add_log(
				attacker.creature_name +
				" usou " +
				attack_data.name +
				"! " +
				target.creature_name +
				" está paralisado!"
			)

func on_switch_pressed():
	
	if is_switching_creature:
		return

	if switch_cooldown > 0:
		hud.add_log(
			"A troca ainda está em cooldown!"
		)
		return

	if switch_menu_open:
		return

	switch_menu_open = true

	set_pause_safe(true)

	var switch_scene = preload(
		"res://Scenes/SwitchMenu.tscn"
	)

	var switch_menu = switch_scene.instantiate()

	switch_menu.forced_mode = false
	switch_menu.current_creature_id = player.creature_id
	switch_menu.creature_hp = player_team_hp.duplicate()

	$CanvasLayer.add_child(switch_menu)

	switch_menu.creature_selected.connect(func(creature_id):

		set_pause_safe(false)

		switch_menu_open = false

		if not is_inside_tree():
			return

		await switch_player_creature(creature_id)
	)

	switch_menu.tree_exited.connect(func():

		switch_menu_open = false

		get_tree().paused = false
	)
	
func switch_player_creature(creature_id, from_death = false):

	if is_switching_creature:
		return

	if not from_death:

		player_team_hp[player.creature_id] = player.hp

		if player.creature_id == creature_id:
			return

		if player_team_hp[creature_id] <= 0:

			hud.add_log(
				"Essa criatura não pode batalhar!"
			)

			return

	else:

		if not player_team_hp.has(creature_id):
			return

		if player_team_hp[creature_id] <= 0:

			hud.add_log(
				"Essa criatura está derrotada!"
			)

			open_forced_switch_menu()

			return

	is_switching_creature = true

	if not from_death:

		switch_cooldown = max_switch_cooldown

		hud.add_log(
			player.creature_name +
			" voltou!"
		)

		await player.play_return_animation()

	player.creature_id = creature_id
	player.load_creature_data()

	player.hp = player_team_hp[creature_id]

	player.burn_active = false
	player.is_paralyzed = false
	player.frozen_attack = ""

	player.scale = player.default_scale
	player.modulate = Color.WHITE

	if player.has_node("Sprite2D"):
		player.get_node("Sprite2D").modulate = Color.WHITE

	if player.has_method("update_status_visual"):
		player.update_status_visual()

	hud.setup(player, enemy)

	hud.add_log(
		"Vai, " +
		player.creature_name +
		"!"
	)

	await player.play_summon_animation()

	is_switching_creature = false
	
func on_run_pressed():

	if run_confirm_open:
		return

	open_run_confirm_popup()
	
func show_result_screen(victory):
	get_tree().paused = true
	
	var result_scene = preload(
		"res://Scenes/ResultScreen.tscn"
	)

	var result_screen = result_scene.instantiate()

	$CanvasLayer.add_child(result_screen)

	result_screen.setup(victory)

func spawn_next_enemy():

	GameData.enemy_index += 1

	enemy.creature_id = GameData.enemy_team[
		GameData.enemy_index
	]

	enemy.load_creature_data()
	apply_enemy_balance()

	enemy.hp = enemy.max_hp

	enemy.burn_active = false
	enemy.is_paralyzed = false
	enemy.frozen_attack = ""

	enemy.scale = enemy.default_scale
	enemy.modulate = Color.WHITE

	await enemy.play_summon_animation()
	
	enemy_ai()

	hud.add_log(
		"Inimigo enviou " +
		enemy.creature_name +
		"!"
	)

func spawn_next_player():

	GameData.player_index += 1

	player.creature_id = GameData.player_team[
		GameData.player_index
	]

	player.load_creature_data()

	player.hp = player.max_hp

	player.burn_active = false
	player.is_paralyzed = false
	player.frozen_attack = ""

	player.scale = player.default_scale
	player.modulate = Color.WHITE

	await player.play_summon_animation()

	hud.add_log(
		"Vai, " +
		player.creature_name +
		"!"
	)

func setup_player_team_hp():

	player_team_hp.clear()

	for creature_id in GameData.player_team:

		var database = preload("res://Scripts/Data/creature_database.gd")

		var max_hp = database.CREATURES[creature_id].max_hp

		player_team_hp[creature_id] = max_hp

func apply_enemy_balance():

	if GameData.battle_number == 0:

		enemy.max_hp = int(enemy.max_hp * 0.7)
		enemy.hp = enemy.max_hp
		enemy.damage_multiplier = 0.7

	else:

		enemy.damage_multiplier = 1.0

func _input(event):

	if not is_pause_key(event):
		return

	if manual_pause_active:

		set_manual_pause(false)

	else:

		# Se já está pausado por popup, troca ou resultado,
		# não deixa a tecla despausar essas telas.
		if get_tree() != null and get_tree().paused:
			return

		set_manual_pause(true)
		
func is_pause_key(event):

	if not event is InputEventKey:
		return false

	if not event.pressed:
		return false

	if event.echo:
		return false

	# Aceita aspas duplas "
	if event.unicode == 34:
		return true

	# Aceita apóstrofo / tecla de aspas em vários teclados
	if event.keycode == KEY_APOSTROPHE:
		return true

	if event.physical_keycode == KEY_APOSTROPHE:
		return true

	return false

func create_manual_pause_screen():

	manual_pause_layer = CanvasLayer.new()
	manual_pause_layer.layer = 50
	manual_pause_layer.visible = false
	manual_pause_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(manual_pause_layer)

	# Indicador no canto esquerdo superior.
	manual_pause_indicator = Label.new()
	manual_pause_indicator.text = "PAUSADO"
	manual_pause_indicator.position = Vector2(25, 18)
	manual_pause_indicator.size = Vector2(260, 42)
	manual_pause_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	manual_pause_indicator.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	manual_pause_indicator.add_theme_font_size_override("font_size", 26)
	manual_pause_indicator.add_theme_color_override("font_color", Color("#FFD84A"))
	manual_pause_indicator.add_theme_color_override("font_outline_color", Color.BLACK)
	manual_pause_indicator.add_theme_constant_override("outline_size", 5)
	manual_pause_indicator.process_mode = Node.PROCESS_MODE_ALWAYS
	manual_pause_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	manual_pause_layer.add_child(manual_pause_indicator)

	# Painel pequeno de ajuda, sem bloquear os ataques.
	var panel = Panel.new()
	panel.position = Vector2(25, 65)
	panel.size = Vector2(390, 115)
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	manual_pause_layer.add_child(panel)

	var text = Label.new()
	text.text = (
		"Jogo pausado.\n" +
		"Passe o mouse nos ataques para ler detalhes,\n" +
		"vantagens e combos.\n\n" +
		"Pressione aspas \" para continuar."
	)
	text.position = Vector2(15, 10)
	text.size = Vector2(360, 95)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size", 15)
	text.process_mode = Node.PROCESS_MODE_ALWAYS
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(text)

func set_manual_pause(active):

	manual_pause_active = active

	if manual_pause_layer != null:
		manual_pause_layer.visible = active

	var tree = get_tree()

	if tree != null:
		tree.paused = active

	print("PAUSE MANUAL:", active)
	
func set_pause_safe(active):

	var tree = get_tree()

	if tree == null:
		return

	tree.paused = active

func open_run_confirm_popup():

	run_confirm_open = true

	get_tree().paused = true

	var layer = CanvasLayer.new()
	layer.name = "RunConfirmLayer"
	layer.layer = 60
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.add_child(layer)

	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.55)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	layer.add_child(overlay)

	var panel = Panel.new()
	panel.anchor_left = 0.5
	panel.anchor_top = 0.5
	panel.anchor_right = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -340
	panel.offset_top = -170
	panel.offset_right = 340
	panel.offset_bottom = 170
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	UISkin.apply_panel_style(panel)
	overlay.add_child(panel)

	var title = Label.new()
	title.text = "Fugir da batalha?"
	title.position = Vector2(0, 30)
	title.size = Vector2(680, 45)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	UISkin.apply_popup_title(title, 26)
	panel.add_child(title)

	var text = Label.new()
	text.text = (
		"Se você fugir agora, a batalha será perdida.\n\n" +
		"Tem certeza que deseja desistir?"
	)
	text.position = Vector2(70, 95)
	text.size = Vector2(540, 90)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UISkin.apply_dark_label(text, 16)
	panel.add_child(text)

	var cancel_button = Button.new()
	cancel_button.text = "Continuar lutando"
	cancel_button.position = Vector2(90, 240)
	cancel_button.size = Vector2(220, 48)
	UISkin.apply_slot_button(cancel_button, 15)
	panel.add_child(cancel_button)

	var confirm_button = Button.new()
	confirm_button.text = "Fugir"
	confirm_button.position = Vector2(370, 240)
	confirm_button.size = Vector2(220, 48)
	UISkin.apply_travel_button(confirm_button, 15)
	panel.add_child(confirm_button)

	cancel_button.pressed.connect(func():

		close_run_confirm_popup(layer)
	)

	confirm_button.pressed.connect(func():

		run_confirm_open = false
		get_tree().paused = false

		layer.queue_free()

		show_result_screen(false)
	)


func close_run_confirm_popup(layer):

	run_confirm_open = false
	get_tree().paused = false

	if layer:
		layer.queue_free()
