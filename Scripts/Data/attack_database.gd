extends Node

const ATTACKS = {

	# ========= NORMAL =========
	
	"scratch": {
		"name": "Arranhar",
		"damage": 8,
		"cooldown": 2.5,
		"type": "normal",
		"effect": "none"
	},
	
	"bite": {
		"name": "Mordida",
		"damage": 10,
		"cooldown": 2.5,
		"type": "normal",
		"effect": "none"
	},
	
	"quick_hit": {
		"name": "Investida",
		"damage": 9,
		"cooldown": 2.0,
		"type": "normal",
		"effect": "none"
	},

	"focus_strike": {
		"name": "Golpe Focado",
		"damage": 16,
		"cooldown": 5.5,
		"type": "normal",
		"effect": "none"
	},
	
	# ========= FIRE =========
	
	"fireball": {
		"name": "Bola de Fogo",
		"damage": 17,
		"cooldown": 6.0,
		"type": "fogo",
		"effect": "none"
	},
	
	"burn": {
		"name": "Bafo de Dragão",
		"damage": 0,
		"cooldown": 8.0,
		"type": "fogo",
		"effect": "burn"
	},
	
	"ember_burst": {
		"name": "Brasas",
		"damage": 13,
		"cooldown": 4.0,
		"type": "fogo",
		"effect": "none"
	},

	"flame_claw": {
		"name": "Garra Flamejante",
		"damage": 15,
		"cooldown": 5.5,
		"type": "fogo",
		"effect": "none"
	},
	
	# ========= WATER =========
	
	"water_blast": {
		"name": "Jato de Água",
		"damage": 14,
		"cooldown": 6.0,
		"type": "água",
		"effect": "none"
	},
	
	"freeze": {
		"name": "Chuva Congelada",
		"damage": 0,
		"cooldown": 8.0,
		"type": "água",
		"effect": "freeze"
	},
	
	"water_drop": {
		"name": "Bolhas d'Água",
		"damage": 10,
		"cooldown": 3.8,
		"type": "água",
		"effect": "none"
	},

	"tide_wave": {
		"name": "Onda Marinha",
		"damage": 16,
		"cooldown": 6.5,
		"type": "água",
		"effect": "none"
	},
	
	# ========= GRASS =========
	
	"leaf_cut": {
		"name": "Folha Cortante",
		"damage": 12,
		"cooldown": 6.0,
		"type": "planta",
		"effect": "none"
	},
	
	"root": {
		"name": "Raízes Paralisantes",
		"damage": 0,
		"cooldown": 8.0,
		"type": "planta",
		"effect": "paralyze"
	},
	
	"vine_whip": {
		"name": "Chicote de Cipó",
		"damage": 12,
		"cooldown": 4.5,
		"type": "planta",
		"effect": "none"
	},

	"seed_shot": {
		"name": "Disparo de Sementes",
		"damage": 15,
		"cooldown": 6.0,
		"type": "planta",
		"effect": "none"
	},
	
	# ========= ELEMENTAL =========

	"elemental_spark": {
		"name": "Pulso Elemental",
		"damage": 13,
		"cooldown": 4.5,
		"type": "elemental",
		"effect": "none"
	},

	"tri_element": {
		"name": "Tríade Elemental",
		"damage": 16,
		"cooldown": 7.0,
		"type": "elemental",
		"effect": "none"
	}
}
