extends Button




func _on_pressed() -> void:
	if not $OptionsMenu.visible:
		$OptionsMenu.visible = true
		AudioManager.play_ui_confirm()
	else:
		$OptionsMenu.visible = false
		AudioManager.play_ui_back()
