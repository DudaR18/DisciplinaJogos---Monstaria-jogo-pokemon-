extends Node2D

@onready var player = $PlayerCreature
@onready var enemy = $EnemyCreature
@onready var hud = $CanvasLayer/BattleHud

var switch_menu_open = false

func _ready():
	enemy_ai()
	player.died.connect(on_player_died)
	enemy.died.connect(on_enemy_died)
	
	hud.setup(player)
	hud.attack_selected.connect(on_attack_selected)

	hud.switch_pressed.connect(on_switch_pressed)
	hud.run_pressed.connect(on_run_pressed)

func on_player_died():
	show_result_screen(false)
	
func on_enemy_died():
	show_result_screen(true)
	
func _process(_delta):
#	if Input.is_action_just_pressed("ui_select"):
#		enemy.attack(player)
		
	#if Input.is_action_just_pressed("ui_accept"):
		#player.attack(enemy, player.attacks[0])
		
	if Input.is_action_just_pressed("q"):
		on_attack_selected(0)

	if Input.is_action_just_pressed("w"):
		on_attack_selected(1)

	if Input.is_action_just_pressed("e"):
		on_attack_selected(2)
	
	hud.update_battle_info(player, enemy)
	
	if Input.is_action_just_pressed("switch creature"):
		on_switch_pressed()

	if Input.is_action_just_pressed("run battle"):
		on_run_pressed()
	
func enemy_ai():

	while enemy.hp > 0 and player.hp > 0:

		await get_tree().create_timer(2.0).timeout
		
		var random_attack = enemy.attacks.pick_random()


		var success = enemy.attack(
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
			
func on_attack_selected(index):

	if index >= player.attacks.size():
		return
		
	var attack_data = player.attacks[index]

	
	var success = player.attack(
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
	
	get_tree().paused = true
	
	if switch_menu_open:
		return

	switch_menu_open = true

	var switch_scene = preload(
		"res://Scenes/SwitchMenu.tscn"
	)

	var switch_menu = switch_scene.instantiate()

	$CanvasLayer.add_child(switch_menu)

	switch_menu.tree_exited.connect(func():
		switch_menu_open = false
	)
	
func on_run_pressed():
	show_result_screen(false)

func show_result_screen(victory):
	get_tree().paused = true
	
	var result_scene = preload(
		"res://Scenes/ResultScreen.tscn"
	)

	var result_screen = result_scene.instantiate()

	$CanvasLayer.add_child(result_screen)

	result_screen.setup(victory)
