extends Node2D

@onready var player = $PlayerCreature
@onready var enemy = $EnemyCreature
@onready var hud = $CanvasLayer/BattleHud

var switch_menu_open = false
var switch_cooldown = 0.0
var max_switch_cooldown = 5.0
var is_switching_creature = false
var run_confirm_open = false
var player_team_hp = {}

func _ready():

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

	player.died.connect(on_player_died)
	enemy.died.connect(on_enemy_died)

	hud.setup(player, enemy)

	hud.attack_selected.connect(on_attack_selected)
	hud.switch_pressed.connect(on_switch_pressed)
	hud.run_pressed.connect(on_run_pressed)

	await player.play_summon_animation()
	await enemy.play_summon_animation()

	enemy_ai()
	
	
func on_player_died():

	if GameData.player_index < GameData.player_team.size() - 1:

		await spawn_next_player()

	else:

		show_result_screen(false)
	
func on_enemy_died():

	print("========")
	print("ENEMY DIED")
	print("INDEX:", GameData.enemy_index)
	print("TEAM:", GameData.enemy_team)
	print("========")

	if GameData.enemy_index < GameData.enemy_team.size() - 1:

		await spawn_next_enemy()

	else:

		GameData.recruit_options = GameData.enemy_team.duplicate()

		get_tree().change_scene_to_file(
			"res://Scenes/RecruitScreen.tscn"
		)
	
func _process(_delta):
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

	get_tree().paused = true

	var switch_scene = preload(
		"res://Scenes/SwitchMenu.tscn"
	)

	var switch_menu = switch_scene.instantiate()

	$CanvasLayer.add_child(switch_menu)

	switch_menu.creature_selected.connect(func(creature_id):

		get_tree().paused = false

		switch_menu_open = false

		switch_player_creature(creature_id)
	)

	switch_menu.tree_exited.connect(func():

		switch_menu_open = false

		get_tree().paused = false
	)
	
func switch_player_creature(creature_id):

	if is_switching_creature:
		return

	player_team_hp[player.creature_id] = player.hp

	if player.creature_id == creature_id:
		return

	if player_team_hp[creature_id] <= 0:

		hud.add_log(
			"Essa criatura não pode batalhar!"
		)

		return

	is_switching_creature = true

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

	run_confirm_open = true

	get_tree().paused = true

	var confirm_scene = preload(
		"res://Scenes/RunConfirm.tscn"
	)

	var confirm_menu = confirm_scene.instantiate()

	$CanvasLayer.add_child(confirm_menu)

	confirm_menu.confirmed.connect(func():

		run_confirm_open = false

		get_tree().paused = false

		show_result_screen(false)
	)

	confirm_menu.cancelled.connect(func():

		run_confirm_open = false

		get_tree().paused = false
	)

	confirm_menu.tree_exited.connect(func():

		run_confirm_open = false
	)
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
