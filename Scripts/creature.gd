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
var paralysis_message_cooldown = false
var frozen_attack = ""
var burn_active = false

var attacks = []
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
	
func attack(target: Creature, attack_data) -> bool:
		
	if attack_cooldowns[attack_data.name] > 0:
		print("Ataque em cooldown!")
		return false
	
	if is_paralyzed:
		
		if not paralysis_message_cooldown:
			paralysis_message_cooldown = true

			var battle = get_parent()

			battle.hud.add_log(
				creature_name +
				" está paralisado!"
			)

			await get_tree().create_timer(1.0).timeout

			paralysis_message_cooldown = false

		return false
		
	if attack_data.name == frozen_attack:
		var battle = get_parent()

		battle.hud.add_log(
			creature_name +
			" não pode usar " +
			attack_data.name +
			" porque está congelado!"
		)

		return false
	
	var final_damage = calculate_damage(
		target,
		attack_data.damage,
		attack_data.type
	)
	
	target.receive_damage(final_damage)
	
	target.apply_effect(attack_data.effect, self)
	
	var battle = get_parent()

	if battle.has_method("show_status_log"):
		battle.show_status_log(
			self,
			target,
			attack_data
		)
		
	print(creature_name, " usou ", attack_data.name)
	
	attack_cooldowns[attack_data.name] = attack_data.cooldown
	
	return true
	
func calculate_damage(target: Creature, base_damage, attack_type):

	var multiplier = get_type_multiplier(
		target,
		attack_type
	)

	return int(base_damage * multiplier)
	
func get_type_multiplier(target, attack_type):

	if attack_type == "fire" and target.creature_type == "grass":
		return 1.5
		
	elif attack_type == "grass" and target.creature_type == "water":
		return 1.5
		
	elif attack_type == "water" and target.creature_type == "fire":
		return 1.5
		
	elif attack_type == target.creature_type:
		return 1.0
		
	else:
		return 0.5
		
# Chama um func de efeito pra aplicar
func apply_effect(effect_name, _attacker):
	
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

		var battle = get_parent()

		battle.hud.add_log(
			"🔥 " +
			creature_name +
			" sofreu 2 de dano de burn!"
		)
		
		
	burn_active = false
	
# Aplica congelamento (agua)
func apply_freeze():
	var available_attacks = []
	
	for attack_data in attacks:
		
		if attack_data.name != "Arranhar":
			available_attacks.append(attack_data)

	if available_attacks.size() <= 0:
		return

	var selected_attack = available_attacks.pick_random()

	frozen_attack = selected_attack.name

	print(
		creature_name +
		" teve o ataque " +
		frozen_attack +
		" congelado!"
	)


	await get_tree().create_timer(5.0).timeout

	frozen_attack = ""
	
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
		
	for attack_data in attacks:
		attack_cooldowns[attack_data.name] = 0.0
	
func show_damage_text(amount):
	
	var damage_scene = preload("res://Scenes/DamageText.tscn")
	var damage_text = damage_scene.instantiate()
	
	get_parent().add_child(damage_text)
	
	damage_text.global_position = global_position
	
	damage_text.show_damage(amount)
