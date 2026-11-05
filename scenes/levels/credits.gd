extends Button



func _on_pressed() -> void:
	if not $CreditsScreen.visible:
		AudioManager.play_ui_confirm()
		$CreditsScreen.visible = true
	else:
		AudioManager.play_ui_back()
		$CreditsScreen.visible = false
