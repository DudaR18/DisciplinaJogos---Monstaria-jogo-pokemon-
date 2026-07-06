extends CharacterBody2D
class_name Creature

@export var is_enemy := false
@export var creature_id = "flameling"
@onready var sprite = $Sprite2D

const STATUS_NORMAL_COLOR = Color(1, 1, 1, 1)
const STATUS_FREEZE_COLOR = Color(0.45, 0.85, 1.0, 1)
const STATUS_PARALYZE_COLOR = Color(1.0, 0.95, 0.25, 1)
const STATUS_BURN_COLOR = Color(1.0, 0.45, 0.15, 1)
const STATUS_DAMAGE_COLOR = Color(1.0, 0.1, 0.1, 1)

var damage_multiplier = 1.0
var sprite_path = ""
var creature_name = ""
var creature_type = ""
var max_hp = 0 #total
var hp = 0 #durante a batalha

var is_paralyzed = false
var paralysis_message_cooldown = false
var frozen_attack = ""
var burn_active = false

var floating_text_queue = []
var floating_text_queue_running = false

var attacks = []
var attack_cooldowns = {}
var global_attack_cooldown_max = 0.0
var global_click_cooldown = 0.0
var global_click_cooldown_time = 1.0
var is_animating_attack = false
var last_combo_text = ""

var default_scale = Vector2.ONE

signal died

func _ready() -> void:

	default_scale = scale

	if is_enemy:
		$Sprite2D.flip_h = true

	load_creature_data()
	hp = max_hp


func _process(delta: float) -> void:
	for attack_name in attack_cooldowns.keys():
		if attack_cooldowns[attack_name] > 0:
			
			attack_cooldowns[attack_name] -= delta
			
			if attack_cooldowns[attack_name] < 0:
				attack_cooldowns[attack_name] = 0
				
	if global_click_cooldown > 0:

		global_click_cooldown -= delta

		if global_click_cooldown < 0:
			global_click_cooldown = 0
		
func receive_damage(amount):
	hp -= amount
	
	play_damage_animation()
	
	if hp <= 0:
		hp = 0
		await play_death_animation()
		died.emit()
		
	print(creature_name, " recebeu ", amount, " de dano")
	print ("HP atual: ", hp)
	
	show_damage_text(amount)
	
func attack(target: Creature, attack_data) -> bool:
	
	if is_animating_attack:
		return false
	
	if global_click_cooldown > 0:
		print("Aguarde para usar outro ataque!")
		return false
	
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
	
	await play_attack_animation()
	
	var final_damage = calculate_damage(
		target,
		attack_data.damage,
		attack_data.type
	)
	
	match attack_data.name:

		"Arranhar", "Investida":
			target.show_attack_effect("slash")

		"Mordida", "Golpe Focado":
			target.show_attack_effect("hit_fogo")

		"Bola de Fogo", "Brasas", "Garra Flamejante":
			target.show_attack_effect("bola_fogo")

		"Bafo de Dragão":
			target.show_attack_effect("bafo_dragao")

		"Jato de Água", "Bolhas d'Água", "Onda Marinha":
			target.show_attack_effect("jato_agua")

		"Chuva Congelada":
			target.show_attack_effect("chuva_congelante")

		"Folha Cortante", "Chicote de Cipó", "Disparo de Sementes":
			target.show_attack_effect("folha_cortante")

		"Raízes Paralisantes":
			target.show_attack_effect("raiz_paralizante")

		"Pulso Elemental", "Tríade Elemental":
			target.show_attack_effect("bafo_dragao")
		
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
	global_click_cooldown = global_click_cooldown_time
	
	return true
	

func calculate_damage(target: Creature, base_damage, attack_type):

	last_combo_text = ""

	var multiplier = get_type_multiplier(
		target,
		attack_type
	)

	var final_damage = int(base_damage * multiplier)

	if target.burn_active and attack_type == "planta":
		final_damage = int(final_damage * 1.5)
		last_combo_text = "COMBO! Ataque de planta causou dano extra em alvo queimado!"
		target.show_floating_text(
			"COMBO!",
			Color.GREEN_YELLOW
		)
		target.show_attack_effect("hit_fogo")
		
	if target.is_paralyzed and attack_type == "normal":
		final_damage = int(final_damage * 1.3)
		last_combo_text = "COMBO! Ataque normal causou dano extra em alvo paralisado!"
		target.show_floating_text(
			"COMBO!",
			Color.GREEN_YELLOW
		)
		target.show_attack_effect("hit_fogo")
		
	if target.frozen_attack != "" and attack_type == "fogo":
		final_damage = int(final_damage * 1.5)
		last_combo_text = "COMBO! Ataque de fogo causou dano extra em alvo congelado!"
		target.show_floating_text(
			"COMBO!",
			Color.GREEN_YELLOW
		)
		target.show_attack_effect("hit_fogo")
		
	final_damage = int(final_damage * damage_multiplier)
	
	return final_damage
	
func get_type_multiplier(target, attack_type):

	if attack_type == "fogo" and target.creature_type == "planta":
		return 1.4
		
	elif attack_type == "planta" and target.creature_type == "água":
		return 1.4
		
	elif attack_type == "água" and target.creature_type == "fogo":
		return 1.4

	elif attack_type == "elemental" and target.creature_type in ["fogo", "água", "planta"]:
		return 1.15

	elif attack_type == "normal" and target.creature_type == "elemental":
		return 1.4

	elif attack_type == "elemental" and target.creature_type == "normal":
		return 0.85
		
	elif attack_type == target.creature_type:
		return 0.8
		
	else:
		return 1.0

func update_status_visual():

	if sprite == null:
		return

	if is_paralyzed:
		sprite.modulate = STATUS_PARALYZE_COLOR

	elif frozen_attack != "":
		sprite.modulate = STATUS_FREEZE_COLOR

	elif burn_active:
		sprite.modulate = STATUS_BURN_COLOR

	else:
		sprite.modulate = STATUS_NORMAL_COLOR
		
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

	update_status_visual()

	show_floating_text(
		"QUEIMANDO!",
		STATUS_BURN_COLOR
	)
	
	for i in range(5):
		
		await get_tree().create_timer(1.0).timeout

		if hp <= 0:
			break
		
		receive_damage(2)

		var battle = get_parent()

		battle.hud.add_log(
			"🔥 " +
			creature_name +
			" sofreu 2 de dano ao queimar!"
		)
		
		
	burn_active = false

	update_status_visual()
	
# Aplica congelamento (agua)
func apply_freeze():

	if frozen_attack != "":
		return

	var available_attacks = []
	
	for attack_data in attacks:
		
		if attack_data.name != "Arranhar":
			available_attacks.append(attack_data)

	if available_attacks.size() <= 0:
		return

	var selected_attack = available_attacks.pick_random()

	frozen_attack = selected_attack.name

	update_status_visual()

	show_floating_text(
		"CONGELADO!",
		STATUS_FREEZE_COLOR
	)

	print(
		creature_name +
		" teve o ataque " +
		frozen_attack +
		" congelado!"
	)

	await get_tree().create_timer(5.0).timeout

	frozen_attack = ""

	update_status_visual()
	
# Aplica paralisia (grama)
func apply_paralyze():
	
	if is_paralyzed:
		return

	is_paralyzed = true

	update_status_visual()

	show_floating_text(
		"PARALISADO!",
		STATUS_PARALYZE_COLOR
	)
	
	print(creature_name, " paralisado e não pode atacar!")
	
	await get_tree().create_timer(2.5).timeout
	
	is_paralyzed = false

	update_status_visual()

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
		
		
	attack_cooldowns.clear()
	
	for attack_data in attacks:
		attack_cooldowns[attack_data.name] = 0.0
	
func show_damage_text(amount):
	var damage_scene = preload("res://Scenes/DamageText.tscn")
	var damage_text = damage_scene.instantiate()
	
	get_parent().add_child(damage_text)
	
	damage_text.global_position = (
		global_position +
		Vector2(0, -10)
	)
	damage_text.show_damage(amount)

func show_floating_text(
	message,
	color = Color.WHITE
):

	floating_text_queue.append({
		"message": message,
		"color": color
	})

	if not floating_text_queue_running:
		process_floating_text_queue()
func process_floating_text_queue():

	floating_text_queue_running = true

	var current_slot = 0

	while not floating_text_queue.is_empty():

		var item = floating_text_queue.pop_front()

		spawn_floating_text(
			item["message"],
			item["color"],
			current_slot
		)

		current_slot += 1

		await get_tree().create_timer(0.22).timeout

	floating_text_queue_running = false


func spawn_floating_text(
	message,
	color,
	slot
):

	var damage_scene = preload(
		"res://Scenes/DamageText.tscn"
	)

	var damage_text = damage_scene.instantiate()

	get_parent().add_child(
		damage_text
	)

	var limited_slot = min(
		slot,
		4
	)

	var x_offset = 0

	if limited_slot % 2 == 1:
		x_offset = 22
	elif limited_slot >= 2:
		x_offset = -22

	damage_text.global_position = (
		global_position +
		Vector2(
			x_offset,
			-75 - limited_slot * 28
		)
	)

	damage_text.z_index = 100 + limited_slot

	damage_text.show_text(
		message,
		color
	)
	
func play_attack_animation():

	if is_animating_attack:
		return

	is_animating_attack = true

	var original_x = position.x

	var direction = 30

	if is_enemy:
		direction = -30

	var tween = create_tween()

	tween.tween_property(
		self,
		"position:x",
		original_x + direction,
		0.1
	)

	tween.tween_property(
		self,
		"position:x",
		original_x,
		0.1
	)

	await tween.finished

	is_animating_attack = false

func play_damage_animation():

	var original_pos = position

	sprite.modulate = STATUS_DAMAGE_COLOR

	var tween = create_tween()

	tween.tween_property(
		self,
		"position",
		original_pos + Vector2(8, 0),
		0.08
	)

	tween.tween_property(
		self,
		"position",
		original_pos + Vector2(-8, 0),
		0.08
	)

	tween.tween_property(
		self,
		"position",
		original_pos,
		0.08
	)

	await tween.finished

	await get_tree().create_timer(0.05).timeout

	update_status_visual()

	await get_tree().create_timer(0.05).timeout

	sprite.modulate = STATUS_DAMAGE_COLOR

	await get_tree().create_timer(0.05).timeout

	update_status_visual()

func play_death_animation():
	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ZERO,
		0.5
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.5
	)

	await tween.finished
	
func play_summon_animation():

	scale = Vector2.ZERO
	modulate.a = 0

	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"scale",
		default_scale,
		0.5
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		1.0,
		0.5
	)

	await tween.finished

func play_return_animation():

	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ZERO,
		0.4
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.4
	)

	await tween.finished
	
func show_attack_effect(animation_name):

	var scene = preload(
		"res://Scenes/AttackEffect.tscn"
	)

	var effect = scene.instantiate()

	get_parent().add_child(effect)

	effect.global_position = (
		global_position +
		Vector2(0, -20)
	)

	effect.play(animation_name)
