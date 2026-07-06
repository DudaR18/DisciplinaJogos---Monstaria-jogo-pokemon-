extends Node

const CreatureDatabase = preload("res://Scripts/Data/creature_database.gd")

var selected_creature = ""

var became_master = false
var demo_finished = false
var result_victory = false

var battle_number = 0
var total_battles = 5

var player_index = 0
var player_team = []

var enemy_team = []
var enemy_index = 0

var recruit_options = []

var current_enemy_dialogue = []
var current_enemy_sprite = ""

var first_battle_tip_shown = false
var elemental_tip_shown = false

const CREATURES_BY_TYPE = {
	"fogo": [
		"flameling",
		"emberfox",
		"lavacub"
	],

	"água": [
		"aquary",
		"tidefin",
		"coralisk"
	],

	"planta": [
		"leafbat",
		"thornling",
		"sproutoad"
	],

	"normal": [
		"pebblit",
		"mimicub"
	],

	"elemental": [
		"prismite",
		"aureon"
	]
}


func _ready():
	randomize()


func generate_enemy_team(player_type):

	match battle_number:

		0:
			generate_first_battle(player_type)

		1:
			generate_second_battle(player_type)

		2:
			generate_third_battle()

		3:
			generate_fourth_battle()

		4:
			generate_final_battle()

		_:
			generate_final_battle()

	enemy_index = 0


func generate_first_battle(player_type):

	match player_type:

		"água":
			enemy_team = [
				"flameling",
				"leafbat"
			]

		"fogo":
			enemy_team = [
				"leafbat",
				"aquary"
			]

		"planta":
			enemy_team = [
				"aquary",
				"flameling"
			]

		_:
			enemy_team = [
				"flameling",
				"leafbat"
			]


func generate_second_battle(player_type):

	match player_type:

		"água":
			enemy_team = [
				"thornling",
				"prismite"
			]

		"fogo":
			enemy_team = [
				"tidefin",
				"pebblit"
			]

		"planta":
			enemy_team = [
				"emberfox",
				"aureon"
			]

		_:
			enemy_team = [
				"coralisk",
				"sproutoad"
			]


func generate_third_battle():

	enemy_team = []

	enemy_team.append(
		get_random_creature_from_types(
			[
				"fogo",
				"água",
				"planta",
				"normal"
			],
			enemy_team
		)
	)

	enemy_team.append(
		get_random_creature_from_types(
			[
				"fogo",
				"água",
				"planta",
				"normal"
			],
			enemy_team
		)
	)

	# O terceiro Pokémon da terceira batalha sempre será elemental.
	enemy_team.append(
		get_random_creature_of_type(
			"elemental",
			enemy_team
		)
	)


func generate_fourth_battle():

	enemy_team = []

	# Garante pelo menos um normal.
	enemy_team.append(
		get_random_creature_of_type(
			"normal",
			enemy_team
		)
	)

	for i in range(3):

		enemy_team.append(
			get_random_creature_from_types(
				[
					"fogo",
					"água",
					"planta",
					"elemental"
				],
				enemy_team
			)
		)

	# O normal pode aparecer em qualquer posição.
	enemy_team.shuffle()


func generate_final_battle():

	enemy_team = []

	var final_types = [
		"fogo",
		"água",
		"planta",
		"normal",
		"elemental"
	]

	for type_name in final_types:

		enemy_team.append(
			get_random_creature_of_type(
				type_name,
				enemy_team
			)
		)

	# A ordem também fica aleatória.
	enemy_team.shuffle()


func get_random_creature_of_type(type_name, blocked_creatures = []):

	var options = []

	for creature_id in CREATURES_BY_TYPE[type_name]:

		if not blocked_creatures.has(creature_id):
			options.append(creature_id)

	if options.is_empty():
		options = CREATURES_BY_TYPE[type_name].duplicate()

	return options.pick_random()


func get_random_creature_from_types(type_list, blocked_creatures = []):

	var options = []

	for type_name in type_list:

		for creature_id in CREATURES_BY_TYPE[type_name]:

			if not blocked_creatures.has(creature_id):
				options.append(creature_id)

	if options.is_empty():

		for type_name in type_list:
			options.append_array(
				CREATURES_BY_TYPE[type_name]
			)

	return options.pick_random()


func get_recruit_options(amount = 2):

	var options = []

	for creature_id in enemy_team:

		if not player_team.has(creature_id):
			options.append(creature_id)

	if options.is_empty():
		options = enemy_team.duplicate()

	options.shuffle()

	var result = []

	for i in range(
		min(amount, options.size())
	):
		result.append(options[i])

	return result


func get_creature_name(creature_id):

	if CreatureDatabase.CREATURES.has(creature_id):
		return CreatureDatabase.CREATURES[creature_id].name

	return creature_id.capitalize()
