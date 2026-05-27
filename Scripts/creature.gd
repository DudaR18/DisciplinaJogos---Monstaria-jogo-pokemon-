extends CharacterBody2D
class_name Creature

@export var creature_id = "flameling"
@onready var sprite = $Sprite2D

var sprite_path = ""
var creature_name = ""
var creature_type = ""
var max_hp = 0 #total
var hp = 0 #durante a batalha

var is_paralyzed = false
var is_frozen = false
var burn_active = false

var attacks = []
var can_attack = true
var attack_cooldowns = {}

signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_creature_data()
	hp = max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for attack_name in attack_cooldowns.keys():
		if attack_cooldowns[attack_name] > 0:
			
			attack_cooldowns[attack_name] -= delta
			
			if attack_cooldowns[attack_name] < 0:
				attack_cooldowns[attack_name] = 0

func receive_damage(amount):
	hp -= amount
	
	if hp <= 0:
		hp = 0
		died.emit()
		
	print(creature_name, " recebeu ", amount, " de dano")
	print ("HP atual: ", hp)
	
	show_damage_text(amount)
	
func attack(target: Creature, attack_data):
	if not can_attack:
		return
		
	if attack_cooldowns[attack_data.name] > 0:
		print("Ataque em cooldown!")
		return
	
	if is_paralyzed:
		print(creature_name, " está paralisado!")
		return
	
	if is_frozen:
		print(creature_name, " está congelado!")
		return
		
	can_attack = false
	
	var final_damage = calculate_damage(
		target,
		attack_data.damage,
		attack_data.type
	)
	
	target.receive_damage(final_damage)
	
	target.apply_effect(attack_data.effect, self)
	
	print(creature_name, " usou ", attack_data.name)
	
	attack_cooldowns[attack_data.name] = attack_data.cooldown
	
	await get_tree().create_timer(attack_data.cooldown).timeout
	
	can_attack = true
	
func calculate_damage(target: Creature, base_damage, attack_type):
	var multiplier = 1.0
	
	if attack_type == "fire" and target.creature_type == "grass": 
		multiplier = 1.5
		
	elif attack_type == "grass" and target.creature_type == "water": 
		multiplier = 1.5
		
	elif attack_type == "water" and target.creature_type == "fire": 
		multiplier = 1.5
	
	elif attack_type == target.creature_type:
		multiplier = 1.0
		
	else:
		multiplier = 0.5
		
	return int(base_damage * multiplier)
	
# Chama um func de efeito pra aplicar
func apply_effect(effect_name, attacker):
	
	match effect_name:
		
		"burn":
			apply_burn()
			
		"freeze":
			apply_freeze()
			
		"paralyze":
			apply_paralyze()

# Aplica paralisia (fogo)
func apply_burn():
	
	if burn_active:
		return
		
	burn_active = true
	
	for i in range(5):
		
		await get_tree().create_timer(1.0).timeout
		
		receive_damage(2)
		
		print(creature_name, " sofreu burn!")
		
		
	burn_active = false
	
# Aplica congelamento (agua)
func apply_freeze():
	
	is_frozen = true
	
	print(creature_name, " congelado e não pode usar uma habilidade!")
	
	await get_tree().create_timer(3.0).timeout
	
	is_frozen = false
	
# Aplica paralisia (grama)
func apply_paralyze():
	
	is_paralyzed = true
	
	print(creature_name, " paralisado enão pode atacar!")
	
	await get_tree().create_timer(2.5).timeout
	
	is_paralyzed = false

# ========= Carregar creatures prontas ============
func load_creature_data():

	var database = preload("res://Scripts/Data/creature_database.gd")
	
	if not database.CREATURES.has(creature_id):
		print("Creature não encontrada: ", creature_id)
		return

	var data = database.CREATURES[creature_id]
	var attack_database = preload("res://Scripts/Data/attack_database.gd")
	
	sprite_path = data.sprite
	creature_name = data.name
	creature_type = data.type
	max_hp = data.max_hp
	
	hp = max_hp
	
	attacks.clear()

	for attack_id in data.attacks:
		attacks.append(
			attack_database.ATTACKS[attack_id]
		)
		
		sprite.texture = load(data.sprite)
		
	for attack in attacks:
		attack_cooldowns[attack.name] = 0.0
	
func show_damage_text(amount):
	
	var damage_scene = preload("res://Scenes/DamageText.tscn")
	var damage_text = damage_scene.instantiate()
	
	get_parent().add_child(damage_text)
	
	damage_text.global_position = global_position
	
	damage_text.show_damage(amount)
