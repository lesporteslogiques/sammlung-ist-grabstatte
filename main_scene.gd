extends Node3D

@onready var guardians = [
	$SubViewportContainer_main/SubViewport_main/gardiens/Gardien,
	$SubViewportContainer_main/SubViewport_main/gardiens/Gardien2,
	$SubViewportContainer_main/SubViewport_main/gardiens/Gardien3,
	$SubViewportContainer_main/SubViewport_main/gardiens/Gardien4,
	$SubViewportContainer_main/SubViewport_main/gardiens/Gardien5
]
@onready var masks = [
	$SubViewportContainer_main/SubViewport_main/masques/Masque1,
	$SubViewportContainer_main/SubViewport_main/masques/Masque2,
	$SubViewportContainer_main/SubViewport_main/masques/Masque3,
	$SubViewportContainer_main/SubViewport_main/masques/Masque4,
	$SubViewportContainer_main/SubViewport_main/masques/Masque5,
	$SubViewportContainer_main/SubViewport_main/masques/Masque6,
	$SubViewportContainer_main/SubViewport_main/masques/Masque7,
	$SubViewportContainer_main/SubViewport_main/masques/Masque8,
	$SubViewportContainer_main/SubViewport_main/masques/Masque9,
	$SubViewportContainer_main/SubViewport_main/masques/Masque10,
	$SubViewportContainer_main/SubViewport_main/masques/Masque11
]

var captured_n := 0

@onready var gameover = $SubViewportContainer_main/SubViewport_main/GameOverScreen
@onready var gamewin = $SubViewportContainer_main/SubViewport_main/GameWinScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewportContainer_main/SubViewport_main/MaskCounter.visible = false
	
	# Connecting all signals
	$SubViewportContainer_main/SubViewport_main/OpeningScreen.connect("play_pressed", _start_game)
	$SubViewportContainer_main/SubViewport_main/OpeningScreen.connect("quit_pressed", get_tree().quit)
	gameover.get_node("AnimationPlayer_fade").connect("animation_finished", _restart_game)
	gamewin.get_node("AnimationPlayer_fade").connect("animation_finished", _restart_game)
	
	for mask in masks:
		mask.connect("mask_captured", _on_mask_captured)
	
	for guardian in guardians:
		guardian.connect("hero_caught", _on_hero_caught)
	
	# Reset mask counter
	$SubViewportContainer_main/SubViewport_main/MaskCounter/Label.text = str(len(masks))
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$SubViewportContainer_main/SubViewport_main/Hero.started = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _start_game() -> void:
	$SubViewportContainer_main/SubViewport_main/OpeningScreen/Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$SubViewportContainer_main/SubViewport_main/OpeningScreen.visible = false
	$SubViewportContainer_main/SubViewport_main/MaskCounter.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$SubViewportContainer_main/SubViewport_main/Hero.reset()


func _restart_game(_animation_name):
	get_tree().reload_current_scene()
	#$SubViewportContainer_main/SubViewport_main/OpeningScreen.visible = true
	#$SubViewportContainer_main/SubViewport_main/MaskCounter.visible = false
	#
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#$SubViewportContainer_main/SubViewport_main/OpeningScreen/Background.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_hero_caught():
	if not $SubViewportContainer_main/SubViewport_main/audio/AudioGameOver.is_playing():
		$SubViewportContainer_main/SubViewport_main/audio/AudioGameOver.play()
	gameover.visible = true
	gameover.get_node("AnimationPlayer_fade").play("FadeinFadeout")
	
	# Disable player collision
	$SubViewportContainer_main/SubViewport_main/Hero.visible = false
	$SubViewportContainer_main/SubViewport_main/MaskCounter.visible = false


func _on_mask_captured():
	print("mask captured")
	captured_n += 1
	$SubViewportContainer_main/SubViewport_main/MaskCounter/Label.text = str(len(masks) - captured_n)
	if captured_n >= len(masks):
		gamewin.visible = true
		gamewin.get_node("AnimationPlayer_fade").play("FadeinFadeout")
