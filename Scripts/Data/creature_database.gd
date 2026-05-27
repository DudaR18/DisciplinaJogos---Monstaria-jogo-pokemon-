extends Node

const CREATURES = {

	"flameling": {
		"name": "Flameling",
		"type": "fire",
		"max_hp": 120,
		"sprite": "res://Assets/Sprites/fogo_frente.png",
		
		"attacks": [
			"scratch",
			"fireball",
			"burn"
		]
	},
	
	
	
	"leafbat": {
		"name": "Leafbat",
		"type": "grass",
		"max_hp": 140,
		"sprite": "res://Assets/Sprites/planta.png",
		
		"attacks": [
			"bite",
			"leaf_cut",
			"root"
		]
	},
	
	
	
	"aquary": {
		"name": "Aquary",
		"type": "water",
		"max_hp": 110,
		"sprite": "res://Assets/Sprites/agua_f.png",
		
		"attacks": [
			"scratch",
			"water_blast",
			"freeze"
		]
	}
}
