extends Node3D

@onready var guardians = [
	$gardiens/Gardien,
	$gardiens/Gardien2,
	$gardiens/Gardien3,
	$gardiens/Gardien4,
	$gardiens/Gardien5
]
@onready var masks = [
	$masques/Masque1,
	$masques/Masque2,
	$masques/Masque3,
	$masques/Masque4,
	$masques/Masque5,
	$masques/Masque6,
	$masques/Masque7,
	$masques/Masque8,
	$masques/Masque9,
	$masques/Masque10,
	$masques/Masque11
]

var captured_n := 0

@onready var gameover = $GameOverScreen
@onready var gamewin = $GameWinScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MaskCounter.visible = false
	
	# Connecting all signals
	$OpeningScreen.connect("play_pressed", _start_game)
	$OpeningScreen.connect("quit_pressed", get_tree().quit)
	gameover.get_node("AnimationPlayer_fade").connect("animation_finished", _restart_game)
	gamewin.get_node("AnimationPlayer_fade").connect("animation_finished", _restart_game)
	
	for mask in masks:
		mask.connect("mask_captured", _on_mask_captured)
	
	for guardian in guardians:
		guardian.connect("hero_caught", _on_hero_caught)
	
	# Reset mask counter
	$MaskCounter/Label.text = str(len(masks))
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Hero.started = false

func _start_game() -> void:
	$OpeningScreen/Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$OpeningScreen.visible = false
	$MaskCounter.visible = true
	$Hero.reset()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _restart_game(_animation_name):
	get_tree().reload_current_scene()

func _on_hero_caught():
	if not $audio/AudioGameOver.is_playing():
		$audio/AudioGameOver.play()
	gameover.visible = true
	gameover.get_node("AnimationPlayer_fade").play("FadeinFadeout")
	
	# Disable player collision
	$Hero.visible = false
	$MaskCounter.visible = false

func _on_mask_captured():
	print("mask captured")
	captured_n += 1
	$MaskCounter/Label.text = str(len(masks) - captured_n)
	if captured_n >= len(masks):
		gamewin.visible = true
		gamewin.get_node("AnimationPlayer_fade").play("FadeinFadeout")
