extends RefCounted
class_name UISkin


const FONT = preload("res://Assets/Fonts/BetterVCR 25.09.ttf")

const POPUP_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Popup01a.png")
const FRAME_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Frame01a.png")
const BUTTON_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_ButtonValue01a.png")
const BUTTON_HOVER_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_ButtonValue01b.png")
const SLOT_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Slot01a.png")
const SLOT_SELECTED_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Slot01b.png")
const SLOT_DISABLED_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Slot01c.png")
const BAR_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Bar01a.png")
const FILL_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_Fill01a.png")
const HEART_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_IconHeart01a.png")
const PAUSE_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_IconPause01a.png")
const STAR_TEXTURE = preload("res://Assets/UI/Sprites/UI_TravelBook_IconStar01a.png")

static func make_texture_style(texture: Texture2D, margin := 4) -> StyleBoxTexture:

	var style = StyleBoxTexture.new()
	style.texture = texture

	style.texture_margin_left = margin
	style.texture_margin_right = margin
	style.texture_margin_top = margin
	style.texture_margin_bottom = margin

	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8

	return style


static func apply_panel_style(panel: Control):

	var style = make_texture_style(
		POPUP_TEXTURE,
		8
	)

	panel.add_theme_stylebox_override(
		"panel",
		style
	)


static func apply_frame_style(panel: Control):

	var style = make_texture_style(
		FRAME_TEXTURE,
		5
	)

	panel.add_theme_stylebox_override(
		"panel",
		style
	)


static func apply_slot_style(panel: Control, selected := false, disabled := false):

	var texture = SLOT_TEXTURE

	if disabled:
		texture = SLOT_DISABLED_TEXTURE
	elif selected:
		texture = SLOT_SELECTED_TEXTURE

	var style = make_texture_style(
		texture,
		6
	)

	panel.add_theme_stylebox_override(
		"panel",
		style
	)


static func apply_button_style(button: Button):

	button.add_theme_font_override(
		"font",
		FONT
	)

	button.add_theme_font_size_override(
		"font_size",
		15
	)

	button.add_theme_color_override(
		"font_color",
		Color("#3B2416")
	)

	button.add_theme_color_override(
		"font_hover_color",
		Color("#1F140D")
	)

	button.add_theme_color_override(
		"font_pressed_color",
		Color("#1F140D")
	)

	button.add_theme_stylebox_override(
		"normal",
		make_texture_style(BUTTON_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"hover",
		make_texture_style(BUTTON_HOVER_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"pressed",
		make_texture_style(BUTTON_HOVER_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"disabled",
		make_texture_style(BUTTON_TEXTURE, 3)
	)


static func apply_label_style(label: Label, font_size := 16):

	label.add_theme_font_override(
		"font",
		FONT
	)

	label.add_theme_font_size_override(
		"font_size",
		font_size
	)

	label.add_theme_color_override(
		"font_color",
		Color("#3B2416")
	)

	label.add_theme_color_override(
		"font_outline_color",
		Color("#F6D6A2")
	)

	label.add_theme_constant_override(
		"outline_size",
		2
	)


static func apply_rich_text_style(text: RichTextLabel, font_size := 15):

	text.add_theme_font_override(
		"normal_font",
		FONT
	)

	text.add_theme_font_override(
		"bold_font",
		FONT
	)

	text.add_theme_font_size_override(
		"normal_font_size",
		font_size
	)

	text.add_theme_font_size_override(
		"bold_font_size",
		font_size
	)

	text.add_theme_color_override(
		"default_color",
		Color("#3B2416")
	)

static func apply_close_button_slot_style(button: Button):

	button.add_theme_font_override(
		"font",
		FONT
	)

	button.add_theme_font_size_override(
		"font_size",
		15
	)

	button.add_theme_color_override(
	"font_color",
	Color("#F6D6A2")
)

	button.add_theme_color_override(
		"font_hover_color",
		Color("#FFFFFF")
	)

	button.add_theme_color_override(
		"font_pressed_color",
		Color("#FFFFFF")
	)

	button.add_theme_color_override(
		"font_disabled_color",
		Color("#D9B982")
	)

	button.add_theme_color_override(
		"font_outline_color",
		Color("#3B2416")
	)

	button.add_theme_constant_override(
		"outline_size",
		2
	)

	var normal_style = make_texture_style(
		SLOT_SELECTED_TEXTURE,
		6
	)

	var hover_style = make_texture_style(
		SLOT_TEXTURE,
		6
	)

	var pressed_style = make_texture_style(
		SLOT_SELECTED_TEXTURE,
		6
	)

	button.add_theme_stylebox_override(
		"normal",
		normal_style
	)

	button.add_theme_stylebox_override(
		"hover",
		hover_style
	)

	button.add_theme_stylebox_override(
		"pressed",
		pressed_style
	)

	button.add_theme_stylebox_override(
		"disabled",
		normal_style
	)
static func apply_screen_title(label: Label, font_size := 32):

	label.add_theme_font_override(
		"font",
		FONT
	)

	label.add_theme_font_size_override(
		"font_size",
		font_size
	)

	label.add_theme_color_override(
		"font_color",
		Color("#F6D6A2")
	)

	label.add_theme_color_override(
		"font_outline_color",
		Color("#3B2416")
	)

	label.add_theme_constant_override(
		"outline_size",
		4
	)


static func apply_dark_label(label: Label, font_size := 16):

	label.add_theme_font_override(
		"font",
		FONT
	)

	label.add_theme_font_size_override(
		"font_size",
		font_size
	)

	label.add_theme_color_override(
		"font_color",
		Color("#3B2416")
	)

	label.add_theme_color_override(
		"font_outline_color",
		Color("#F6D6A2")
	)

	label.add_theme_constant_override(
		"outline_size",
		1
	)


static func apply_light_label(label: Label, font_size := 16):

	label.add_theme_font_override(
		"font",
		FONT
	)

	label.add_theme_font_size_override(
		"font_size",
		font_size
	)

	label.add_theme_color_override(
		"font_color",
		Color("#F6D6A2")
	)

	label.add_theme_color_override(
		"font_outline_color",
		Color("#3B2416")
	)

	label.add_theme_constant_override(
		"outline_size",
		2
	)


static func apply_travel_button(button: Button, font_size := 15):

	button.add_theme_font_override(
		"font",
		FONT
	)

	button.add_theme_font_size_override(
		"font_size",
		font_size
	)

	button.add_theme_color_override(
		"font_color",
		Color("#3B2416")
	)

	button.add_theme_color_override(
		"font_hover_color",
		Color("#1F140D")
	)

	button.add_theme_color_override(
		"font_pressed_color",
		Color("#1F140D")
	)

	button.add_theme_color_override(
		"font_disabled_color",
		Color("#7A5A44")
	)

	button.add_theme_stylebox_override(
		"normal",
		make_texture_style(BUTTON_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"hover",
		make_texture_style(BUTTON_HOVER_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"pressed",
		make_texture_style(BUTTON_HOVER_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"disabled",
		make_texture_style(BUTTON_TEXTURE, 3)
	)


static func apply_slot_button(button: Button, font_size := 15):

	button.add_theme_font_override(
		"font",
		FONT
	)

	button.add_theme_font_size_override(
		"font_size",
		font_size
	)

	button.add_theme_color_override(
		"font_color",
		Color("#F6D6A2")
	)

	button.add_theme_color_override(
		"font_hover_color",
		Color("#FFFFFF")
	)

	button.add_theme_color_override(
		"font_pressed_color",
		Color("#FFFFFF")
	)

	button.add_theme_color_override(
		"font_outline_color",
		Color("#3B2416")
	)

	button.add_theme_constant_override(
		"outline_size",
		2
	)

	button.add_theme_stylebox_override(
		"normal",
		make_texture_style(SLOT_SELECTED_TEXTURE, 6)
	)

	button.add_theme_stylebox_override(
		"hover",
		make_texture_style(SLOT_TEXTURE, 6)
	)

	button.add_theme_stylebox_override(
		"pressed",
		make_texture_style(SLOT_SELECTED_TEXTURE, 6)
	)

	button.add_theme_stylebox_override(
		"disabled",
		make_texture_style(SLOT_DISABLED_TEXTURE, 6)
	)


static func apply_hp_bar(bar):

	if bar == null:
		return

	if bar is TextureProgressBar:

		bar.texture_under = BAR_TEXTURE
		bar.texture_progress = FILL_TEXTURE

	else:

		bar.add_theme_stylebox_override(
			"background",
			make_texture_style(BAR_TEXTURE, 4)
		)

		bar.add_theme_stylebox_override(
			"fill",
			make_texture_style(FILL_TEXTURE, 4)
		)


static func apply_travel_rich_text(text: RichTextLabel, font_size := 15):

	text.add_theme_font_override(
		"normal_font",
		FONT
	)

	text.add_theme_font_override(
		"bold_font",
		FONT
	)

	text.add_theme_font_size_override(
		"normal_font_size",
		font_size
	)

	text.add_theme_font_size_override(
		"bold_font_size",
		font_size
	)

	text.add_theme_color_override(
		"default_color",
		Color("#3B2416")
	)

static func apply_travel2_button(button: Button, font_size := 15):

	button.add_theme_font_override(
		"font",
		FONT
	)

	button.add_theme_font_size_override(
		"font_size",
		font_size
	)

	button.add_theme_color_override(
		"font_color",
		Color("#F6D6A2")
	)

	button.add_theme_color_override(
		"font_hover_color",
		Color("#1F140D")
	)

	button.add_theme_color_override(
		"font_pressed_color",
		Color("#1F140D")
	)

	button.add_theme_color_override(
		"font_disabled_color",
		Color("#7A5A44")
	)

	button.add_theme_stylebox_override(
		"normal",
		make_texture_style(BUTTON_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"hover",
		make_texture_style(BUTTON_HOVER_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"pressed",
		make_texture_style(BUTTON_HOVER_TEXTURE, 3)
	)

	button.add_theme_stylebox_override(
		"disabled",
		make_texture_style(BUTTON_TEXTURE, 3)
	)

static func apply_popup_title(label: Label, font_size := 24):

	label.add_theme_font_override(
		"font",
		FONT
	)

	label.add_theme_font_size_override(
		"font_size",
		font_size
	)

	label.add_theme_color_override(
		"font_color",
		Color("#3B2416")
	)

	label.add_theme_color_override(
		"font_outline_color",
		Color("#F6D6A2")
	)

	label.add_theme_constant_override(
		"outline_size",
		2
	)
