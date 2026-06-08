extends Node

var selected_creature = ""

var became_master = false
var demo_finished = false
var result_victory = false

var battle_number = 0
var player_index = 0
var player_team = []

var enemy_team = []
var enemy_index = 0
var enemy_battles = [

	["flameling", "leafbat"],

	["aquary", "flameling"],

	["leafbat", "aquary"]
]

var recruit_options = []

var current_enemy_dialogue = []
var current_enemy_sprite = ""

func generate_enemy_team(player_type):

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

	enemy_index = 0
