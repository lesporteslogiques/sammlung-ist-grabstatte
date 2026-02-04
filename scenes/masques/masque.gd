extends Node3D

signal mask_captured()

@export var sprite: Resource
@export var sound: Resource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite3D.texture = sprite
	$Sprite3D.scale = Vector3(2, 2, 2)
	
	$AudioAmb.stream = sound
	#$AudioAmb.volume_db = -30
	$AudioAmb.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Hero:
		$Area3D.monitoring = false
		$AudioStreamPlayer3D.play()
		$AnimationPlayer.play("free")
		emit_signal("mask_captured")


func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
