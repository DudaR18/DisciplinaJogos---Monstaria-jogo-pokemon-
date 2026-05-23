extends Node2D

@onready var player = $PlayerCreature
@onready var enemy = $EnemyCreature

func _ready():
	enemy_ai()
	player.died.connect(on_player_died)
	enemy.died.connect(on_enemy_died)

func on_player_died():
	print("VOCÊ PERDEU")
	
	
func on_enemy_died():
	print("VOCÊ VENCEU")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		enemy.attack(player)
		
func enemy_ai():
	while enemy.hp > 0 and player.hp > 0:
		
		await get_tree().create_timer(2.0).timeout
		
		enemy.attack(player)
