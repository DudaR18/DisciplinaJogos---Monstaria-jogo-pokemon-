extends Node2D

@onready var player = $PlayerCreature
@onready var enemy = $EnemyCreature
@onready var hud = $CanvasLayer/BattleHud


func _ready():
	enemy_ai()
	player.died.connect(on_player_died)
	enemy.died.connect(on_enemy_died)
	
	hud.setup(player)
	hud.attack_selected.connect(on_attack_selected)

func on_player_died():
	print("VOCÊ PERDEU, MELHORE.")
	
	
func on_enemy_died():
	print("SEU INIMIGO FOI DERROTADO! VOCÊ VENCEU O JOGO!")
	
func _process(delta):
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
	
func enemy_ai():
	while enemy.hp > 0 and player.hp > 0:

		await get_tree().create_timer(2.0).timeout

		var random_attack = enemy.attacks.pick_random()

		enemy.attack(
			player,
			random_attack
		)
	
func on_attack_selected(index):
	
	if index >= player.attacks.size():
		return
		
	player.attack(
		enemy,
		player.attacks[index]
	)
