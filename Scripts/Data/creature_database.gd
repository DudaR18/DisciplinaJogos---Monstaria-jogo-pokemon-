extends Node

const CREATURES = {

	"flameling": {
		"name": "Flameling",
		"type": "fogo",
		"max_hp": 120,
		"sprite": "res://Assets/Sprites/flame.png",
		
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
		"sprite": "res://Assets/Sprites/base-leafbat.png",
		
		"attacks": [
			"bite",
			"leaf_cut",
			"root"
		]
	},
	
	
	
	"aquary": {
		"name": "Aquary",
		"type": "água",
		"max_hp": 110,
		"sprite": "res://Assets/Sprites/base-aquary.png",
		
		"attacks": [
			"scratch",
			"water_blast",
			"freeze"
		]
	}
}
