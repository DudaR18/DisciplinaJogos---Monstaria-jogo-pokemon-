extends Control

const UISkin = preload("res://Scripts/ui_skin.gd")

@onready var tip_text = $Panel/TipTexte
@onready var continue_button = $Panel/ContinueButton


var tip_mode = "first_battle"


func _ready():

	get_tree().paused = true
	
	UISkin.apply_panel_style($Panel)
	UISkin.apply_travel_rich_text(tip_text, 16)
	UISkin.apply_travel_button(continue_button, 16)
	
	tip_text.bbcode_enabled = true

	match tip_mode:

		"elemental":
			tip_text.text = get_elemental_tip_text()

		_:
			tip_text.text = get_first_battle_tip_text()


func get_first_battle_tip_text():

	return (
		"[center][b]Sua primeira batalha começou![/b][/center]\n\n" +
		"[color=yellow]Monstaria é um jogo em tempo real.[/color]\n" +
		"O inimigo não vai esperar você escolher com calma.\n\n" +

		"Use seus ataques para derrotar as criaturas adversárias:\n\n" +
		"[b]Q[/b] - Ataque básico\n" +
		"[b]W[/b] - Ataque elemental\n" +
		"[b]E[/b] - Habilidade especial\n\n" +

		"[color=cyan]Dica:[/color] depois de atacar, existe uma pequena trava geral.\n" +
		"Mas o cooldown principal de cada ataque é individual.\n\n" +

		"[color=#FFAA00][b]Importante:[/b][/color] passe o mouse sobre os botões de ataque " +
		"para ver dano, tipo, efeito, vantagem e possíveis [b]COMBOS[/b].\n\n" +

		"[b]\"[/b] - Pausar ou continuar a batalha\n" +
		"Use a pausa para ler as informações da tela com calma.\n\n" +

		"[color=lime]Vença os inimigos[/color] para recrutar uma nova criatura!"
	)
func get_elemental_tip_text():

	return (
		"[center][b]Novos tipos apareceram![/b][/center]\n\n" +
		"[color=#B35CFF]Pokémon elementais[/color] misturam forças da natureza.\n" +
		"Eles são fortes contra [color=red]fogo[/color], [color=cyan]água[/color] e [color=lime]planta[/color].\n\n" +
		"Mas eles têm uma fraqueza importante:\n" +
		"[color=white]Pokémon do tipo normal[/color] causam mais dano contra elementais.\n\n" +
		"Tipo normal não tem elemento especial, mas é estável e confiável.\n" +
		"Use isso para montar melhor sua equipe nas próximas batalhas!"
	)


func close_popup():

	get_tree().paused = false

	queue_free()


func _on_continue_button_pressed() -> void:

	close_popup()
