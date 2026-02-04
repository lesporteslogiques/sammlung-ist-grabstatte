extends Node

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		fix_mouse_input()

func fix_mouse_input():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		await get_tree().process_frame
		await get_tree().process_frame
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
