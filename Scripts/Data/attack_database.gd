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
	
	
	
	# ========= FIRE =========
	
	"fireball": {
		"name": "Bola de Fogo",
		"damage": 16,
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
	
	
	
	# ========= GRASS =========
	
	"leaf_cut": {
		"name": "Folha Cortante",
		"damage": 802,
		"cooldown": 0.0,
		"type": "planta",
		"effect": "none"
	},
	
	"root": {
		"name": "Raízes Paralisantes",
		"damage": 0,
		"cooldown": 8.0,
		"type": "planta",
		"effect": "paralyze"
	}
}
