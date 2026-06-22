extends Control

signal confirmed
signal cancelled

@onready var yes_button = $CenterContainer/Panel/VBoxContainer/YesButton
@onready var no_button = $CenterContainer/Panel/VBoxContainer/NoButton

func _ready():
	yes_button.pressed.connect(confirm_run)
	no_button.pressed.connect(cancel_run)

func confirm_run():
	confirmed.emit()
	queue_free()

func cancel_run():
	cancelled.emit()
	queue_free()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		cancel_run()
