extends Control

const TITLE_FONT = preload("res://Assets/Fonts/GrapeSoda.ttf")
const CONTENT_FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")
const UISkin = preload("res://Scripts/ui_skin.gd")

@onready var play_button = $CenterContainer/VBoxContainer/PlayButton
@onready var dicas_button = $CenterContainer/VBoxContainer/DicasButton
@onready var exit_button = $CenterContainer/VBoxContainer/ExitButton
@onready var cheat_button = $CenterContainer/VBoxContainer/CheatButton

var tips_layer: CanvasLayer


func _ready():

	play_button.pressed.connect(start_game)
	dicas_button.pressed.connect(open_tips)
	if cheat_button:
		cheat_button.pressed.connect(go_to_victory_cheat)
	exit_button.pressed.connect(exit_game)
	
	apply_main_menu_skin()
	create_tips_screen()

func apply_main_menu_skin():

	UISkin.apply_travel2_button(play_button, 24)

	if dicas_button:
		UISkin.apply_travel2_button(dicas_button, 24)

	if cheat_button:
		UISkin.apply_travel2_button(cheat_button, 20)

	UISkin.apply_travel2_button(exit_button, 22)
	
func create_tips_screen():

	tips_layer = CanvasLayer.new()
	tips_layer.layer = 20
	tips_layer.visible = false
	add_child(tips_layer)

	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.72)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	tips_layer.add_child(overlay)

	var panel = Panel.new()
	panel.anchor_left = 0.5
	panel.anchor_top = 0.5
	panel.anchor_right = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -560
	panel.offset_top = -320
	panel.offset_right = 560
	panel.offset_bottom = 320
	UISkin.apply_panel_style(panel)
	overlay.add_child(panel)

	var title = Label.new()
	title.text = "DICAS DE MONSTARIA"
	title.position = Vector2(0, 20)
	title.size = Vector2(1120, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", TITLE_FONT)
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.add_theme_color_override("font_outline_color", Color("#1A2541"))
	title.add_theme_constant_override("outline_size", 4)
	UISkin.apply_dark_label(title, 36)
	panel.add_child(title)

	var tips_text = RichTextLabel.new()
	tips_text.position = Vector2(70, 95)
	tips_text.size = Vector2(980, 430)
	tips_text.bbcode_enabled = true
	tips_text.scroll_active = true
	tips_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tips_text.add_theme_font_override("normal_font", CONTENT_FONT)
	tips_text.add_theme_font_override("bold_font", CONTENT_FONT)
	tips_text.add_theme_font_size_override("normal_font_size", 18)
	tips_text.text = get_tips_text()
	UISkin.apply_travel_rich_text(tips_text, 16)
	panel.add_child(tips_text)

	var close_button = Button.new()
	close_button.text = "Voltar"
	close_button.position = Vector2(245, 560)
	close_button.size = Vector2(220, 45)
	close_button.add_theme_font_override("font", CONTENT_FONT)
	close_button.add_theme_font_size_override("font_size", 18)
	UISkin.apply_slot_button(close_button, 16)
	panel.add_child(close_button)

	close_button.pressed.connect(close_tips)

	var play_now_button = Button.new()
	play_now_button.text = "Começar aventura"
	play_now_button.position = Vector2(655, 560)
	play_now_button.size = Vector2(240, 45)
	play_now_button.add_theme_font_override("font", CONTENT_FONT)
	play_now_button.add_theme_font_size_override("font_size", 18)
	UISkin.apply_travel_button(play_now_button, 16)
	panel.add_child(play_now_button)

	play_now_button.pressed.connect(start_game)


func get_tips_text():

	return (
		"[center][b]Bem-vindo ao mundo de Monstaria![/b][/center]\n\n" +

		"Em [b]Monstaria[/b], você escolhe uma criatura inicial e entra em batalhas em tempo real. " +
		"O inimigo não espera você escolher com calma, então é importante atacar, trocar criaturas e pensar rápido.\n\n" +

		"[b][color=#FFD84A]BATALHAS[/color][/b]\n" +
		"As batalhas ficam maiores conforme você avança. No começo os inimigos usam poucas criaturas, " +
		"mas depois passam a usar equipes maiores e tipos diferentes. " +
		"Depois de vencer uma batalha, você pode recrutar uma nova criatura para fortalecer seu time.\n\n" +

		"[b][color=#55CC55]VANTAGENS DE TIPOS[/color][/b]\n" +
		"Cada criatura possui um tipo, e isso altera o dano causado:\n\n" +

		"[color=#FF5555]Fogo[/color] causa mais dano em [color=#55CC55]Planta[/color].\n" +
		"[color=#55CC55]Planta[/color] causa mais dano em [color=#4AA3FF]Água[/color].\n" +
		"[color=#4AA3FF]Água[/color] causa mais dano em [color=#FF5555]Fogo[/color].\n" +
		"[color=#B35CFF]Elemental[/color] é forte contra Fogo, Água e Planta.\n" +
		"[color=#DDDDDD]Normal[/color] é forte contra Elemental.\n\n" +

		"Atacar uma criatura do mesmo tipo causa menos dano, então escolher bem o ataque é essencial.\n\n" +

		"[b][color=#4AA3FF]TROCAS DE CRIATURAS[/color][/b]\n" +
		"Durante a batalha, você pode trocar sua criatura. " +
		"Isso serve para fugir de uma desvantagem de tipo ou preparar uma estratégia melhor. " +
		"A vida da criatura continua como estava durante a mesma batalha, então trocar não cura automaticamente.\n\n" +

		"[b][color=#FFAA00]COMBOS — MUITO IMPORTANTE[/color][/b]\n" +
		"[color=#FFAA00]Monstaria não é só apertar os ataques quando eles ficam disponíveis.[/color]\n" +
		"Para vencer as batalhas mais difíceis, você precisa combinar ataques, efeitos e trocas.\n\n" +

		"[b]Exemplos de combos:[/b]\n" +
		"• Use [b]queimadura[/b] para causar dano ao longo do tempo.\n" +
		"• Use [b]congelamento[/b] para ganhar tempo enquanto seus ataques recarregam.\n" +
		"• Use [b]paralisia[/b] para travar o inimigo e trocar para uma criatura com vantagem.\n" +
		"• Troque para uma criatura forte contra o inimigo antes de usar seu ataque principal.\n" +
		"• Guarde criaturas do tipo [color=#DDDDDD]Normal[/color] para enfrentar inimigos [color=#B35CFF]Elementais[/color].\n\n" +

		"[center][b][color=#FFAA00]Quem entende os combos vence mais do que quem só aperta botão![/color][/b][/center]\n\n" +

		"[b][color=#B35CFF]COMO SE TORNAR UM MESTRE[/color][/b]\n" +
		"Para se tornar um Mestre de Monstaria, você precisa vencer todas as cinco batalhas. " +
		"Na última batalha, o inimigo terá uma criatura de cada tipo: Fogo, Água, Planta, Normal e Elemental.\n\n" +

		"Monte uma equipe equilibrada, recrute bem, use trocas no momento certo e combine efeitos para dominar as batalhas!"
	)


func open_tips():

	tips_layer.visible = true


func close_tips():

	tips_layer.visible = false


func start_game():

	get_tree().change_scene_to_file(
		"res://Scenes/IntroductionScreen.tscn"
	)


func exit_game():

	get_tree().quit()


func _on_tip_button_pressed() -> void:
	pass # Replace with function body.

func go_to_victory_cheat():

	GameData.player_team.clear()

	GameData.player_team = [
		"flameling",
		"aquary",
		"leafbat",
		"pebblit",
		"prismite"
	]

	GameData.selected_creature = "flameling"

	GameData.battle_number = GameData.total_battles
	GameData.player_index = 0
	GameData.enemy_index = 0

	GameData.enemy_team.clear()
	GameData.recruit_options.clear()

	GameData.became_master = true
	GameData.result_victory = true
	GameData.demo_finished = true

	get_tree().change_scene_to_file(
		"res://Scenes/VictoryScreen.tscn"
	)
