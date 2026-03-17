extends Node3D

var captured_n := 0
var number_of_mask_to_capture := 0

@onready var gameover = $GameOverScreen
@onready var gamewin = $GameWinScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup
	$MaskCounter.visible = false
	
	# Connecting all signals
	$OpeningScreen.connect("play_pressed", _start_game)
	$OpeningScreen.connect("quit_pressed", get_tree().quit)
	gameover.get_node("AnimationPlayer_fade").connect("animation_finished", _restart_game)
	gamewin.get_node("AnimationPlayer_fade").connect("animation_finished", _restart_game)

	for gardien:AnimatableBody3D in $gardiens.get_children():
		gardien.connect("hero_caught", _on_hero_caught)

	for mask:Node3D in $masques.get_children():
		number_of_mask_to_capture += 1
		mask.connect("mask_captured", _on_mask_captured)
	
	# Reset mask counter
	$MaskCounter/Label.text = str(number_of_mask_to_capture)
	
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
	$MaskCounter/Label.text = str(number_of_mask_to_capture - captured_n)
	if captured_n >= number_of_mask_to_capture:
		gamewin.visible = true
		gamewin.get_node("AnimationPlayer_fade").play("FadeinFadeout")
