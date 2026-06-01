extends Node

const ATTACKS = {

	# ========= NORMAL =========
	
	"scratch": {
		"name": "Arranhar",
		"damage": 8,
		"cooldown": 1.0,
		"type": "normal",
		"effect": "none"
	},
	
	"bite": {
		"name": "Mordida",
		"damage": 10,
		"cooldown": 1.5,
		"type": "normal",
		"effect": "none"
	},
	
	
	
	# ========= FIRE =========
	
	"fireball": {
		"name": "Bola de Fogo",
		"damage": 16,
		"cooldown": 4.0,
		"type": "fire",
		"effect": "none"
	},
	
	"burn": {
		"name": "Bafo de Dragão",
		"damage": 0,
		"cooldown": 6.0,
		"type": "fire",
		"effect": "burn"
	},
	
	
	
	# ========= WATER =========
	
	"water_blast": {
		"name": "Jato de Água",
		"damage": 14,
		"cooldown": 4.0,
		"type": "water",
		"effect": "none"
	},
	
	"freeze": {
		"name": "Chuva Congelada",
		"damage": 0,
		"cooldown": 6.0,
		"type": "water",
		"effect": "freeze"
	},
	
	
	
	# ========= GRASS =========
	
	"leaf_cut": {
		"name": "Folha Cortante",
		"damage": 12,
		"cooldown": 4.0,
		"type": "grass",
		"effect": "none"
	},
	
	"root": {
		"name": "Raízes Paralisantes",
		"damage": 0,
		"cooldown": 6.0,
		"type": "grass",
		"effect": "paralyze"
	}
}
