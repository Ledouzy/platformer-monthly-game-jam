extends Button



func _on_pressed() -> void:
	if not $CreditsScreen.visible:
		$CreditsScreen.visible = true
	else:
		$CreditsScreen.visible = false
