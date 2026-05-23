extends CharacterBody2D
class_name Creature

signal died

@export var creature_name = "Monster"
@export var creature_type = "fire"


@export var max_hp = 100
var hp = 100

@export var attack_damage = 10
@export var attack_cooldown = 2.0

var can_attack = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_damage(amount):
	hp -= amount
	
	if hp <= 0:
		hp = 0
		died.emit()
		
	print(creature_name, " recebeu ", amount, " de dano")
	print ("HP atual: ", hp)
	
func attack(target: Creature):
	if not can_attack:
		return
		
	can_attack = false
	
	var final_damage = calculate_damage(target)
	target.receive_damage(final_damage)
	
	print(creature_name, " atacou!")
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true
	
func calculate_damage(target: Creature):
	var multiplier = 1.0
	
	if creature_type == "fire" and target.creature_type == "grass": 
		multiplier = 1.5
		
	elif creature_type == "grass" and target.creature_type == "water": 
		multiplier = 1.5
		
	elif creature_type == "water" and target.creature_type == "fire": 
		multiplier = 1.5
	
	elif target.creature_type == creature_type:
		multiplier = 1.0
		
	else:
		multiplier = 0.5
		
	return int(attack_damage * multiplier)
