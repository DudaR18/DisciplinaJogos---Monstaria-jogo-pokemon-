extends Label

func show_text(message, color = Color.WHITE):

	text = str(message)

	modulate = color

	var tween = create_tween()

	tween.tween_property(
		self,
		"position:y",
		position.y - 50,
		1.0
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		1.0
	)

	await tween.finished

	queue_free()


func show_damage(amount):

	show_text(amount)
