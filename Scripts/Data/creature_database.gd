extends Node

const CREATURES = {

# ============ Starters ============ 
	"flameling": {
		"name": "Flameling",
		"type": "fogo",
		"max_hp": 110,
		"sprite": "res://Assets/Sprites/Flame.png",
		
		"attacks": [
			"scratch",
			"fireball",
			"burn"
		]
	},
	
	"leafbat": {
		"name": "Leafbat",
		"type": "planta",
		"max_hp": 140,
		"sprite": "res://Assets/Sprites/gramastarter.png",
		
		"attacks": [
			"bite",
			"leaf_cut",
			"root"
		]
	},
	
	"aquary": {
		"name": "Aquary",
		"type": "água",
		"max_hp": 120,
		"sprite": "res://Assets/Sprites/aguastarter.png",
		
		"attacks": [
			"scratch",
			"water_blast",
			"freeze"
		]
	},
	
	# ========= FOGO =========

	"emberfox": {
		"name": "Emberfox",
		"type": "fogo",
		"max_hp": 115,
		"sprite": "res://Assets/Sprites/fogo1.png",
		"attacks": [
			"quick_hit",
			"ember_burst",
			"burn"
		]
	},

	"lavacub": {
		"name": "Lavacub",
		"type": "fogo",
		"max_hp": 150,
		"sprite": "res://Assets/Sprites/fogo2.png",
		"attacks": [
			"bite",
			"flame_claw",
			"fireball"
		]
	},


	# ========= ÁGUA =========

	"tidefin": {
		"name": "Tidefin",
		"type": "água",
		"max_hp": 125,
		"sprite": "res://Assets/Sprites/agua1.png",
		"attacks": [
			"quick_hit",
			"water_drop",
			"freeze"
		]
	},

	"coralisk": {
		"name": "Coralisk",
		"type": "água",
		"max_hp": 145,
		"sprite": "res://Assets/Sprites/agua2.png",
		"attacks": [
			"bite",
			"tide_wave",
			"water_blast"
		]
	},


	# ========= PLANTA =========

	"thornling": {
		"name": "Thornling",
		"type": "planta",
		"max_hp": 135,
		"sprite": "res://Assets/Sprites/grama1.png",
		"attacks": [
			"bite",
			"vine_whip",
			"root"
		]
	},

	"sproutoad": {
		"name": "Sproutoad",
		"type": "planta",
		"max_hp": 140,
		"sprite": "res://Assets/Sprites/grama2.png",
		"attacks": [
			"scratch",
			"seed_shot",
			"leaf_cut"
		]
	},


	# ========= NORMAL =========

	"pebblit": {
		"name": "Pebblit",
		"type": "normal",
		"max_hp": 130,
		"sprite": "res://Assets/Sprites/normal1.png",
		"attacks": [
			"quick_hit",
			"bite",
			"focus_strike"
		]
	},

	"mimicub": {
		"name": "Mimicub",
		"type": "normal",
		"max_hp": 120,
		"sprite": "res://Assets/Sprites/normal2.png",
		"attacks": [
			"scratch",
			"quick_hit",
			"focus_strike"
		]
	},


	# ========= ELEMENTAL =========

	"prismite": {
		"name": "Prismite",
		"type": "elemental",
		"max_hp": 135,
		"sprite": "res://Assets/Sprites/elemental3.png",
		"attacks": [
			"quick_hit",
			"elemental_spark",
			"tri_element"
		]
	},

	"aureon": {
		"name": "Aureon",
		"type": "elemental",
		"max_hp": 160,
		"sprite": "res://Assets/Sprites/elemental2.png",
		"attacks": [
			"bite",
			"elemental_spark",
			"tri_element"
		]
	}
}
