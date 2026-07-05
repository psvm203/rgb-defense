extends CanvasLayer

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://track/track.tscn")


func _on_settings_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
