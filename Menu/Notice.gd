extends Label

const buffer : float = 0.05

onready var font_color : Color = get("custom_colors/font_color")
onready var fluctuation : float = -0.01

func _ready():
	font_color.a = 0.5
	print(font_color)

func _process(delta):
	font_color.a += fluctuation
	if font_color.a < buffer || font_color.a > 1 - (buffer):
		fluctuation = -fluctuation
	set("custom_colors/font_color", font_color)

