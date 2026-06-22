extends Node2D

@onready var sprite = $AnimatedSprite2D

func play(animation_name):

	match animation_name:

		"slash":
			sprite.scale = Vector2(2.5, 2.5)

		"hit_fogo":
			sprite.scale = Vector2(3.5, 3.5)

		"bola_fogo":
			sprite.scale = Vector2(2.0, 2.0)

		"bafo_dragao":
			sprite.scale = Vector2(3.5, 3.5)

		"jato_agua":
			sprite.scale = Vector2(2.0, 2.0)

		"chuva_congelante":
			sprite.scale = Vector2(2.0, 2.0)

		"folha_cortante":
			sprite.scale = Vector2(3.0, 3.0)

		"raiz_paralisante":
			sprite.scale = Vector2(2.2, 2.2)


	sprite.play(animation_name)

	await sprite.animation_finished

	queue_free()
