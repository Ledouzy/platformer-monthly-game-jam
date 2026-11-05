extends Button




func _on_pressed() -> void:
	if not $OptionsMenu.visible:
		$OptionsMenu.visible = true
	else:
		$OptionsMenu.visible = false
